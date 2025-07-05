import cvxpy as cp
import numpy as np

# 1. 定义上下文 (Context) - 与之前版本相同
class CorrelatedContext:
    def __init__(self):
        self.Omega = [0, 1]
        self.Theta = [0, 1]
        self.A = [0, 1]
        self.b = 10.0  # 公开预算
        self.M = 10.0  # 卖方预算

        # mu(theta, omega) - 注意为了方便索引，我们将theta作为第一维
        self.mu_joint = np.array([[0.4, 0.1],  # theta=0: mu(t=0,w=0), mu(t=0,w=1)
                                  [0.1, 0.4]]) # theta=1: mu(t=1,w=0), mu(t=1,w=1)
        self.mu_theta = np.sum(self.mu_joint, axis=1) # [0.5, 0.5]
        self.mu_omega = np.sum(self.mu_joint, axis=0) # [0.5, 0.5]

        # mu(omega | theta)
        self.mu_cond_w_given_t = self.mu_joint / self.mu_theta[:, np.newaxis]

    def u(self, omega, action):
        return 10.0 if omega == action else 0.0

# 2. 构建并求解线性规划 (CM-probR) - 修正版
def solve_cm_probr_corrected(ctx):
    # ==================
    # 1. 定义LP变量
    # ==================
    # z[theta_rep, o, a_rec, w]
    # theta_rep: 报告的类型
    # o: 支付结果 (0: 支付b, 1: 支付-M)
    # a_rec: 推荐的行动
    # w: 真实的世界状态
    z = cp.Variable((len(ctx.Theta), 2, len(ctx.A), len(ctx.Omega)), nonneg=True)

    # ==================
    # 2. 定义目标函数
    # ==================
    # 收益 = sum_{theta, o, a, w} z * (payment_o)
    # 注意 z 已经是联合概率 mu(theta,omega)*p(...)，所以不需要再乘以 mu(theta)
    payments = np.array([ctx.b, -ctx.M])
    # 使用einsum进行高效的点积求和
    revenue = cp.sum(cp.multiply(z, payments[np.newaxis, :, np.newaxis, np.newaxis]))
    objective = cp.Maximize(revenue)

    # ==================
    # 3. 定义约束
    # ==================
    constraints = []

    # 3.1 可行性约束 (Feasibility)
    # sum_{o, a} z[theta, o, a, w] = mu(theta, w)
    for t_idx in range(len(ctx.Theta)):
        for w_idx in range(len(ctx.Omega)):
            constraints.append(cp.sum(z[t_idx, :, :, w_idx]) == ctx.mu_joint[t_idx, w_idx])

    # 3.2 听话约束 (Obedience)
    # 当被推荐行动 a_rec 时，买方选择 a_rec 的效用 >= 选择任何其他 a_dev 的效用
    for t_rep_idx in range(len(ctx.Theta)):
        for a_rec_idx, a_rec in enumerate(ctx.A):
            # 支付 b 的情况
            util_obedient_b = sum(z[t_rep_idx, 0, a_rec_idx, w_idx] * ctx.u(ctx.Omega[w_idx], a_rec) 
                                 for w_idx in range(len(ctx.Omega)))
            # 支付 -M 的情况
            util_obedient_m = sum(z[t_rep_idx, 1, a_rec_idx, w_idx] * ctx.u(ctx.Omega[w_idx], a_rec) 
                                 for w_idx in range(len(ctx.Omega)))
            
            for a_dev_idx, a_dev in enumerate(ctx.A):
                if a_rec_idx != a_dev_idx:
                    # 支付 b 的情况
                    util_deviate_b = sum(z[t_rep_idx, 0, a_rec_idx, w_idx] * ctx.u(ctx.Omega[w_idx], a_dev) 
                                        for w_idx in range(len(ctx.Omega)))
                    constraints.append(util_obedient_b >= util_deviate_b)
                    
                    # 支付 -M 的情况
                    util_deviate_m = sum(z[t_rep_idx, 1, a_rec_idx, w_idx] * ctx.u(ctx.Omega[w_idx], a_dev) 
                                        for w_idx in range(len(ctx.Omega)))
                    constraints.append(util_obedient_m >= util_deviate_m)

    # 3.3 激励相容(IC)和个体理性(IR)约束
    # 我们需要先定义各种情况下的期望净效用
    
    # U_net[theta_true, theta_rep]
    # 表示真实类型为 theta_true 的买方，报告自己是 theta_rep 时，获得的期望净效用
    U_net = [[None for _ in ctx.Theta] for _ in ctx.Theta]

    for t_true_idx in range(len(ctx.Theta)):
        for t_rep_idx in range(len(ctx.Theta)):
            # 由于听话约束，买方在收到推荐后会听话。
            # 所以他的期望效用是基于推荐行动的。
            
            # 支付 b 的情况
            expected_gross_util_b = sum(z[t_rep_idx, 0, a_idx, w_idx] * ctx.u(ctx.Omega[w_idx], ctx.A[a_idx])
                                       for a_idx in range(len(ctx.A))
                                       for w_idx in range(len(ctx.Omega))
                                       if ctx.mu_joint[t_true_idx, w_idx] > 0) # 条件期望在真实类型上
            
            expected_payment_b = sum(z[t_rep_idx, 0, a_idx, w_idx] * ctx.b
                                    for a_idx in range(len(ctx.A))
                                    for w_idx in range(len(ctx.Omega))
                                    if ctx.mu_joint[t_true_idx, w_idx] > 0)

            # 支付 -M 的情况
            expected_gross_util_m = sum(z[t_rep_idx, 1, a_idx, w_idx] * ctx.u(ctx.Omega[w_idx], ctx.A[a_idx])
                                       for a_idx in range(len(ctx.A))
                                       for w_idx in range(len(ctx.Omega))
                                       if ctx.mu_joint[t_true_idx, w_idx] > 0)
            
            expected_payment_m = sum(z[t_rep_idx, 1, a_idx, w_idx] * (-ctx.M)
                                    for a_idx in range(len(ctx.A))
                                    for w_idx in range(len(ctx.Omega))
                                    if ctx.mu_joint[t_true_idx, w_idx] > 0)

            # 这里的期望需要除以 P(theta_true)
            mu_t_true = ctx.mu_theta[t_true_idx]
            if mu_t_true > 1e-9:
                U_net[t_true_idx][t_rep_idx] = (expected_gross_util_b + expected_gross_util_m - expected_payment_b - expected_payment_m) / mu_t_true
            else:
                U_net[t_true_idx][t_rep_idx] = 0


    # 添加 IC 和 IR 约束
    for t_true_idx in range(len(ctx.Theta)):
        # IR 约束: 说真话的效用 >= 不参与的保留效用
        # 保留效用计算
        u_prior = -np.inf
        prior_dist = ctx.mu_cond_w_given_t[t_true_idx, :]
        for a_idx, a in enumerate(ctx.A):
            util = sum(prior_dist[w_idx] * ctx.u(ctx.Omega[w_idx], a) for w_idx in range(len(ctx.Omega)))
            u_prior = max(u_prior, util)
        
        constraints.append(U_net[t_true_idx][t_true_idx] >= u_prior)
        
        # IC 约束: 说真话的效用 >= 说假话的效用
        for t_rep_idx in range(len(ctx.Theta)):
            if t_true_idx != t_rep_idx:
                constraints.append(U_net[t_true_idx][t_true_idx] >= U_net[t_true_idx][t_rep_idx])


    # ==================
    # 4. 求解问题
    # ==================
    problem = cp.Problem(objective, constraints)
    # 使用一个鲁棒性更好的求解器
    problem.solve(solver=cp.SCS, verbose=False)

    print("--- LP Solver Results (Corrected) ---")
    print(f"Solver status: {problem.status}")
    if problem.value is not None:
        print(f"Optimal Revenue: {problem.value:.4f}")
    
    # ==================
    # 5. 打印和解释结果
    # ==================
    if problem.status in [cp.OPTIMAL, cp.OPTIMAL_INACCURATE]:
        z_val = z.value
        print("\n--- Optimal Mechanism Policy ---")
        for t_rep_idx in range(len(ctx.Theta)):
            print(f"\nIf buyer reports type theta={t_rep_idx}:")
            # 转换为条件概率 p(o, a | w, theta_rep)
            p = np.zeros_like(z_val[t_rep_idx])
            for w_idx in range(len(ctx.Omega)):
                mu_tw = ctx.mu_joint[t_rep_idx, w_idx]
                if mu_tw > 1e-9:
                    p[:, :, w_idx] = z_val[t_rep_idx, :, :, w_idx] / mu_tw
                else: # 如果 mu(theta,omega)=0, 那么 z 也必须是 0
                    p[:, :, w_idx] = 0

            for w_idx, w in enumerate(ctx.Omega):
                print(f"  If seller observes omega={w}:")
                has_action = False
                for a_idx, a in enumerate(ctx.A):
                    prob_pay_b = p[0, a_idx, w_idx]
                    prob_pay_m = p[1, a_idx, w_idx]
                    if prob_pay_b > 1e-6:
                        print(f"    -> Recommend action '{a}', charge {ctx.b} (Prob: {prob_pay_b:.2f})")
                        has_action = True
                    if prob_pay_m > 1e-6:
                        print(f"    -> Recommend action '{a}', pay back {ctx.M} (Prob: {prob_pay_m:.2f})")
                        has_action = True
                if not has_action:
                     print("    -> No action recommended.")


# --- 主程序 ---
if __name__ == "__main__":
    ctx_corr = CorrelatedContext()
    solve_cm_probr_corrected(ctx_corr)