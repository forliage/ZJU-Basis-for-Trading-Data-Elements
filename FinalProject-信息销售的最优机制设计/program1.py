import numpy as np
import matplotlib.pyplot as plt

# 1. 定义上下文 (Context)
class Context:
    def __init__(self):
        self.Omega = [0, 1]
        self.Theta = [0, 1]
        self.A = [0, 1]
        
        # 联合概率分布 mu(omega, theta)
        self.mu_joint = np.array([[0.4, 0.1],  # theta=0: mu(w=0|t=0)=0.4, mu(w=1|t=0)=0.1
                                  [0.1, 0.4]]) # theta=1: mu(w=0|t=1)=0.1, mu(w=1|t=1)=0.4
        
        # 边际概率分布
        self.mu_theta = np.sum(self.mu_joint, axis=0) # [0.5, 0.5]
        self.mu_omega = np.sum(self.mu_joint, axis=1) # [0.5, 0.5]
        
        # 条件概率分布 mu(omega | theta)
        self.mu_cond_w_given_t = self.mu_joint / self.mu_theta
        
    def u(self, omega, action):
        """效用函数，为了简化，这里不依赖于theta"""
        return 10.0 if omega == action else 0.0

# 2. 计算信息的价值 xi(theta)
def calculate_xi(context, theta):
    """计算类型为theta的买方，获得完整信息omega的价值"""
    
    # 2.1 计算无额外信息时的期望效用 U_prior
    expected_utilities_prior = []
    for action in context.A:
        utility = 0
        for omega_idx, omega in enumerate(context.Omega):
            prob_w = context.mu_cond_w_given_t[omega_idx, theta]
            utility += prob_w * context.u(omega, action)
        expected_utilities_prior.append(utility)
    
    u_prior = np.max(expected_utilities_prior)
    best_action_prior = np.argmax(expected_utilities_prior)

    # 2.2 计算拥有完整信息时的期望效用 U_post
    u_post = 0
    for omega_idx, omega in enumerate(context.Omega):
        prob_w = context.mu_cond_w_given_t[omega_idx, theta]
        
        # 对于给定的omega, 找到最优行动
        best_utility_for_omega = 0
        for action in context.A:
            best_utility_for_omega = max(best_utility_for_omega, context.u(omega, action))
        
        u_post += prob_w * best_utility_for_omega

    xi = u_post - u_prior
    print(f"对于买方类型 theta={theta}:")
    print(f"  无信息时的最优行动是 a={best_action_prior}, 期望效用 U_prior = {u_prior:.2f}")
    print(f"  有信息时的期望效用 U_post = {u_post:.2f}")
    print(f"  信息的价值 xi(theta) = {xi:.2f}\n")
    return xi

# 3. 计算“密封信封”机制的收益
def sealed_envelope_revenue(t, xi_values, mu_theta):
    """对于给定的价格t, 计算卖方收益"""
    revenue = 0
    for theta_idx, xi in enumerate(xi_values):
        if xi >= t:
            revenue += t * mu_theta[theta_idx]
    return revenue

# --- 主程序 ---
if __name__ == "__main__":
    ctx = Context()
    
    # 计算每种买方类型的信息价值
    xi_values = [calculate_xi(ctx, theta) for theta in ctx.Theta]
    
    # 寻找最优的“密封信封”价格 t*
    # 我们可以通过在合理范围内搜索t来找到最优值
    prices_to_test = np.linspace(0, max(xi_values) + 1, 1000)
    revenues = [sealed_envelope_revenue(t, xi_values, ctx.mu_theta) for t in prices_to_test]
    
    max_revenue = np.max(revenues)
    optimal_price = prices_to_test[np.argmax(revenues)]
    
    print(f"“密封信封”机制分析:")
    print(f"  最优定价 t* = {optimal_price:.2f}")
    print(f"  可获得的最大收益 = {max_revenue:.2f}")

    # 可视化收益曲线
    plt.figure(figsize=(10, 6))
    plt.plot(prices_to_test, revenues)
    plt.title("Revenue of Sealed Envelope Mechanism vs. Price (t)")
    plt.xlabel("Price (t)")
    plt.ylabel("Expected Revenue")
    plt.axvline(x=optimal_price, color='r', linestyle='--', label=f'Optimal Price t* = {optimal_price:.2f}')
    plt.grid(True)
    plt.legend()
    plt.show()