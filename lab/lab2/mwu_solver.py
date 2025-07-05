import numpy as np
import matplotlib.pyplot as plt

class MWUNashSolver:
    """
    Parameters:
        payoff_matrix: 收益矩阵
        epsilon: 学习率参数 
        max_iter: 最大迭代次数
    """
    def __init__(self, payoff_matrix: np.ndarray, 
                 epsilon: float = 0.1,
                 max_iter: int = 1000):

        self.original_M = payoff_matrix.copy()
        self.M = self._normalize_payoff_matrix(payoff_matrix) # 归一化收益矩阵
        self.epsilon = epsilon
        self.max_iter = max_iter
        self.history = {
            'iterations': [],
            'row_average_regret': [],
            'col_average_regret': [],
        }
    
    def _normalize_payoff_matrix(self, payoff_matrix: np.ndarray) -> np.ndarray:
        """归一化收益矩阵到 [0, 1] 范围"""
        min_val = np.min(payoff_matrix)
        max_val = np.max(payoff_matrix)
        
        # 避免除零错误
        if max_val == min_val:
            return np.zeros_like(payoff_matrix)
        
        normalized = (payoff_matrix - min_val) / (max_val - min_val)
        return normalized
    
    def find_equilibrium(self) -> tuple[np.ndarray, np.ndarray]:
        """运行算法并记录收敛指标"""
        n, m = self.M.shape
        
        cumulative_actual_payoff = 0  # Σ_{t=1}^T U(x_t, y_t)
        cumulative_pure_row_payoffs = np.zeros(n)  # Σ_{t=1}^T U(i, y_t) for each i
        cumulative_pure_col_payoffs = np.zeros(m)  # Σ_{t=1}^T U(x_t, j) for each j
        row_strategy_history = []
        
        # 初始化权重（只有列玩家使用MWU）
        w_col = np.ones(m)  # 列玩家权重
        for t in range(1, self.max_iter + 1):

            """
            TODO: 请同学们自行设计列玩家和行玩家选择策略的部分。
            具体步骤如下：
            1. 列玩家根据当前的权重向量 $w$ 计算列玩家的策略 $y$；
            2. 行玩家根据列玩家的策略 $y$ 计算行玩家的最佳应对策略 $x$（注意 x 为纯策略）；
            3. 列玩家根据行玩家的策略 $x$ 计算 cost 向量；
            4. 列玩家根据 cost 向量更新权重向量 $w$；
            """

            # ------------------------------------------------------------
            # 请在下方填写你的代码，实现完成后可以将 exception 注释
            # raise NotImplementedError("MWU solver not implemented.")
            w_col_sum = np.sum(w_col)
            if w_col_sum > 1e-8: 
                y = w_col / w_col_sum
            else:
                y = np.ones(m) / m
            row_payoffs = self.M @ y
            best_row_action_idx = np.argmax(row_payoffs)
            x = np.zeros(n)
            x[best_row_action_idx] = 1.0
            cost_vector = x @ self.M
            w_col = w_col * (1 - self.epsilon * cost_vector)

            # ------------------------------------------------------------
            
            row_strategy_history.append(x.copy())
            current_payoff = x @ self.M @ y
            cumulative_actual_payoff += current_payoff
            cumulative_pure_row_payoffs += self.M @ y 
            cumulative_pure_col_payoffs += x @ self.M 
            row_regret = np.max(cumulative_pure_row_payoffs) - cumulative_actual_payoff
            col_regret = cumulative_actual_payoff - np.min(cumulative_pure_col_payoffs)
            self.history['iterations'].append(t)
            self.history['row_average_regret'].append(row_regret / t)
            self.history['col_average_regret'].append(col_regret / t)
            
        # 计算行玩家的统计学意义上的平均策略（最终呈现为均衡策略）
        x_avg = np.mean(row_strategy_history, axis=0)
        
        return x_avg, y
        
    def plot_convergence(self, figsize=(12, 5)):
        """绘制列玩家的regret收敛过程（全过程和后一半）"""
        fig, axes = plt.subplots(1, 2, figsize=figsize)
        
        half_idx = len(self.history['iterations']) // 2
        iterations_half = self.history['iterations'][half_idx:]
        col_regret_half = self.history['col_average_regret'][half_idx:]
        
        axes[0].plot(self.history['iterations'], self.history['col_average_regret'],
                    'g-', label='Column Player Regret', linewidth=2)
        axes[0].set_xlabel('Iterations')
        axes[0].set_ylabel('Average Regret')
        axes[0].set_title('Column Player Average Regret (Full Process)')
        axes[0].legend()
        axes[0].grid(True, alpha=0.3)
        
        axes[1].plot(iterations_half, col_regret_half,
                    'g-', label='Column Player Regret', linewidth=2)
        axes[1].set_xlabel('Iterations')
        axes[1].set_ylabel('Average Regret')
        axes[1].set_title('Column Player Average Regret (Second Half)')
        axes[1].legend()
        axes[1].grid(True, alpha=0.3)

        plt.tight_layout()
        plt.show()