# nash_verifier.py
import numpy as np

class NashVerifier:
    """极简纳什均衡验证器（仅检查最优响应）"""
    
    def __init__(self, payoff_matrix: np.ndarray):
        self.M = payoff_matrix  # 行玩家收益矩阵
        self.n_rows, self.n_cols = payoff_matrix.shape
    
    def is_equilibrium(self, 
                      row_strategy: np.ndarray, 
                      col_strategy: np.ndarray,
                      tol: float = 1e-2) -> bool:
        """
        检查是否为纳什均衡（双方是否都是最优响应）
        
        参数:
            row_strategy: 行玩家混合策略（概率向量）
            col_strategy: 列玩家混合策略（概率向量）
            tol: 数值容忍度，默认1e-2，不需要改动
            
        返回:
            bool: 是否为均衡
        """
        
        # 请在下方填写你的代码，实现完成后可以将 exception 注释
        # raise NotImplementedError("NashVerifier is not implemented.")

        current_row_payoff = row_strategy @ self.M @ col_strategy
        
        row_pure_strategy_payoffs = self.M @ col_strategy
        
        max_row_payoff = np.max(row_pure_strategy_payoffs)
        
        if not np.isclose(current_row_payoff, max_row_payoff, atol=tol):
            return False

        current_col_payoff = - (row_strategy @ self.M @ col_strategy)

        col_pure_strategy_payoffs = - (row_strategy @ self.M)

        max_col_payoff = np.max(col_pure_strategy_payoffs)

        if not np.isclose(current_col_payoff, max_col_payoff, atol=tol):
            return False
        return True
        