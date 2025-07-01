import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import beta

# --- 1. 创建老虎机环境 ---
class BernoulliBandit:
    """
    一个伯努利多臂老虎机环境。
    
    参数:
    p_arms (list): 每个臂的真实成功概率列表。
    """
    def __init__(self, p_arms):
        self.p_arms = np.array(p_arms)
        self.K = len(p_arms)
        self.best_arm_p = np.max(self.p_arms)

    def pull(self, arm_index):
        """
        拉动一个臂，根据其概率返回奖励 (0 或 1)。
        """
        if np.random.rand() < self.p_arms[arm_index]:
            return 1
        return 0

# --- 2. 实现 UCB1 算法 ---
class UCB1:
    """
    UCB1 算法实现。
    
    参数:
    K (int): 臂的数量。
    c (float): 探索因子，通常设置为 2。
    """
    def __init__(self, K, c=2):
        self.K = K
        self.c = c
        self.counts = np.zeros(K, dtype=int)  # 每个臂被拉动的次数 N(a)
        self.q_values = np.zeros(K, dtype=float) # 每个臂的平均奖励 Q(a)
        self.t = 0 # 总步数

    def select_arm(self):
        """
        根据 UCB1 规则选择一个臂。
        """
        # 优先选择没有被拉动过的臂
        untried_arms = np.where(self.counts == 0)[0]
        if len(untried_arms) > 0:
            return untried_arms[0]
        
        # 计算所有臂的 UCB 值
        ucb_values = self.q_values + self.c * np.sqrt(np.log(self.t) / self.counts)
        return np.argmax(ucb_values)

    def update(self, arm_index, reward):
        """
        更新被选中臂的统计数据。
        """
        self.t += 1
        self.counts[arm_index] += 1
        # 使用增量式更新平均值，以提高数值稳定性
        self.q_values[arm_index] += (reward - self.q_values[arm_index]) / self.counts[arm_index]

# --- 3. 实现汤普森采样算法 ---
class ThompsonSampling:
    """
    用于伯努利老虎机的汤普森采样算法实现。
    
    参数:
    K (int): 臂的数量。
    """
    def __init__(self, K):
        self.K = K
        # 初始化 Beta 分布的参数 (alpha, beta)，初始为 (1, 1) 代表均匀先验
        self.alpha = np.ones(K)
        self.beta = np.ones(K)

    def select_arm(self):
        """
        从每个臂的后验分布中采样并选择最优的。
        """
        samples = [beta.rvs(self.alpha[i], self.beta[i]) for i in range(self.K)]
        return np.argmax(samples)

    def update(self, arm_index, reward):
        """
        根据奖励更新后验分布的参数。
        """
        if reward == 1:
            self.alpha[arm_index] += 1
        else:
            self.beta[arm_index] += 1
            
# --- 4. 运行模拟 ---
def run_simulation(bandit, algorithm, horizon):
    """
    在给定的 bandit 环境和算法下运行单次模拟。
    
    返回:
    cumulative_regret_history (list): 每一步的累积遗憾列表。
    """
    cumulative_regret = 0
    cumulative_regret_history = []
    
    # 获取每个臂的真实概率以便计算遗憾
    p_arms = bandit.p_arms
    best_p = bandit.best_arm_p

    for t in range(horizon):
        # 1. 算法选择一个臂
        chosen_arm = algorithm.select_arm()
        
        # 2. 环境返回奖励
        reward = bandit.pull(chosen_arm)
        
        # 3. 算法更新内部状态
        algorithm.update(chosen_arm, reward)
        
        # 4. 计算并累积遗憾
        instant_regret = best_p - p_arms[chosen_arm]
        cumulative_regret += instant_regret
        cumulative_regret_history.append(cumulative_regret)
        
    return cumulative_regret_history

# --- 5. 主程序和可视化 ---
if __name__ == "__main__":
    # 模拟参数
    HORIZON = 10000  # 总时间步长
    N_SIMULATIONS = 500  # 模拟运行的总次数，用于求平均
    
    # 老虎机臂的真实概率 (选择一个有些挑战性的问题)
    ARM_PROBABILITIES = [0.2, 0.4, 0.6, 0.8, 0.9]
    K = len(ARM_PROBABILITIES)

    # 初始化用于存储所有模拟结果的数组
    ucb_regrets = np.zeros((N_SIMULATIONS, HORIZON))
    ts_regrets = np.zeros((N_SIMULATIONS, HORIZON))

    print("正在运行模拟...")
    for i in range(N_SIMULATIONS):
        if (i + 1) % 50 == 0:
            print(f"  完成 {i+1}/{N_SIMULATIONS} 次模拟...")
            
        # 每次模拟都使用全新的 bandit 和 algorithm 实例
        bandit = BernoulliBandit(p_arms=ARM_PROBABILITIES)
        ucb_algo = UCB1(K=K, c=2)
        ts_algo = ThompsonSampling(K=K)
        
        ucb_regrets[i, :] = run_simulation(bandit, ucb_algo, HORIZON)
        
        # 重新创建 bandit 实例以保证 TS 在完全相同的条件下开始
        bandit = BernoulliBandit(p_arms=ARM_PROBABILITIES)
        ts_regrets[i, :] = run_simulation(bandit, ts_algo, HORIZON)

    # 计算平均累积遗憾
    avg_ucb_regret = np.mean(ucb_regrets, axis=0)
    avg_ts_regret = np.mean(ts_regrets, axis=0)

    print("模拟完成！正在绘制结果...")

    # 绘图
    plt.figure(figsize=(12, 7))
    plt.plot(avg_ts_regret, label="Thompson Sampling")
    plt.plot(avg_ucb_regret, label="UCB1 (c=2)")
    
    plt.title(f"UCB1 vs. Thompson Sampling (平均 {N_SIMULATIONS} 次运行)")
    plt.xlabel("时间步 (Time Steps)")
    plt.ylabel("平均累积遗憾 (Average Cumulative Regret)")
    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.show()