"""
双人零和博弈类定义

定义一个标准的双人零和博弈接口，统一收益矩阵的表示和计算
"""

import numpy as np
from typing import Tuple

class ZeroSumGame:
    """
    定义一个两人零和博弈，用收益矩阵表示
    
    参数:
        payoff_matrix (np.ndarray): 行玩家的收益矩阵（列玩家的收益矩阵为负）
    """
    def __init__(self, payoff_matrix: np.ndarray):
        """
        初始化零和博弈
        
        Args:
            payoff_matrix: 行玩家（玩家1）的收益矩阵，列玩家（玩家2）的收益为其负数
        """
        self.payoff_matrix = payoff_matrix.astype(np.float64)
        self.n_rows = payoff_matrix.shape[0]
        self.n_cols = payoff_matrix.shape[1]
        
    def row_player_payoff(self, row_strategy: np.ndarray, col_strategy: np.ndarray) -> float:
        """
        计算行玩家（玩家1）的期望收益
        
        Args:
            row_strategy: 行玩家的混合策略
            col_strategy: 列玩家的混合策略
            
        Returns:
            行玩家的期望收益
        """
        return row_strategy.T @ self.payoff_matrix @ col_strategy
    
    def col_player_payoff(self, row_strategy: np.ndarray, col_strategy: np.ndarray) -> float:
        """
        计算列玩家（玩家2）的期望收益（即行玩家收益的负数）
        
        Args:
            row_strategy: 行玩家的混合策略
            col_strategy: 列玩家的混合策略
            
        Returns:
            列玩家的期望收益
        """
        return -self.row_player_payoff(row_strategy, col_strategy)
    
    def get_payoffs(self, row_strategy: np.ndarray, col_strategy: np.ndarray) -> Tuple[float, float]:
        """
        同时计算两个玩家的期望收益
        
        Args:
            row_strategy: 行玩家的混合策略
            col_strategy: 列玩家的混合策略
            
        Returns:
            (行玩家收益, 列玩家收益)
        """
        row_payoff = self.row_player_payoff(row_strategy, col_strategy)
        return row_payoff, -row_payoff
    
    def best_response_row(self, col_strategy: np.ndarray) -> np.ndarray:
        """
        计算行玩家对列玩家策略的最佳响应
        
        Args:
            col_strategy: 列玩家的混合策略
            
        Returns:
            行玩家的最佳响应策略（纯策略，one-hot向量）
        """
        utilities = self.payoff_matrix @ col_strategy
        best_action = np.argmax(utilities)
        best_response = np.zeros(self.n_rows)
        best_response[best_action] = 1.0
        return best_response
    
    def best_response_col(self, row_strategy: np.ndarray) -> np.ndarray:
        """
        计算列玩家对行玩家策略的最佳响应
        
        Args:
            row_strategy: 行玩家的混合策略
            
        Returns:
            列玩家的最佳响应策略（纯策略，one-hot向量）
        """
        utilities = row_strategy.T @ self.payoff_matrix
        best_action = np.argmin(utilities)  # 列玩家要最小化行玩家的收益
        best_response = np.zeros(self.n_cols)
        best_response[best_action] = 1.0
        return best_response
    
    def compute_exploitability(self, row_strategy: np.ndarray, col_strategy: np.ndarray) -> float:
        """
        计算策略组合的可利用性（exploitability）
        
        Args:
            row_strategy: 行玩家的混合策略
            col_strategy: 列玩家的混合策略
            
        Returns:
            可利用性值（越小表示越接近纳什均衡）
        """
        # 当前收益
        current_row_payoff = self.row_player_payoff(row_strategy, col_strategy)
        current_col_payoff = self.col_player_payoff(row_strategy, col_strategy)
        
        # 最佳响应收益
        best_row_response = self.best_response_row(col_strategy)
        best_col_response = self.best_response_col(row_strategy)
        
        best_row_payoff = self.row_player_payoff(best_row_response, col_strategy)
        best_col_payoff = self.col_player_payoff(row_strategy, best_col_response)
        
        # 后悔值
        row_regret = best_row_payoff - current_row_payoff
        col_regret = best_col_payoff - current_col_payoff
        
        # 可利用性是两个玩家后悔值的平均
        return (row_regret + col_regret) / 2
    
    def is_nash_equilibrium(self, row_strategy: np.ndarray, col_strategy: np.ndarray, 
                           tolerance: float = 1e-6) -> bool:
        """
        检查策略组合是否为纳什均衡
        
        Args:
            row_strategy: 行玩家的混合策略
            col_strategy: 列玩家的混合策略
            tolerance: 数值容忍度
            
        Returns:
            是否为纳什均衡
        """
        exploitability = self.compute_exploitability(row_strategy, col_strategy)
        return exploitability < tolerance
    
    def get_game_info(self) -> dict:
        """
        获取博弈的基本信息
        
        Returns:
            包含博弈信息的字典
        """
        return {
            'shape': (self.n_rows, self.n_cols),
            'min_payoff': float(np.min(self.payoff_matrix)),
            'max_payoff': float(np.max(self.payoff_matrix)),
            'mean_payoff': float(np.mean(self.payoff_matrix)),
            'std_payoff': float(np.std(self.payoff_matrix))
        }
    
    def __str__(self) -> str:
        """字符串表示"""
        return f"ZeroSumGame({self.n_rows}×{self.n_cols})"
    
    def __repr__(self) -> str:
        """详细字符串表示"""
        info = self.get_game_info()
        return (f"ZeroSumGame(shape={info['shape']}, "
                f"payoff_range=[{info['min_payoff']:.3f}, {info['max_payoff']:.3f}])") 