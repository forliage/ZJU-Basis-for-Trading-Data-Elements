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
        raise NotImplementedError("NashVerifier is not implemented.")
        
        # 检查行玩家是否最优
        
        
        # 检查列玩家是否最优
        