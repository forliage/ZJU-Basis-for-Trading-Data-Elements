"""
博弈矩阵生成器

生成石头剪刀布、5 x 5 和 10 x 10 随机矩阵，保存到 dataset 文件夹
"""

import numpy as np
import os
from zero_sum_game import ZeroSumGame
import time
class GameGenerator:
    """简化的博弈生成器"""
    
    def __init__(self, dataset_dir: str = "dataset"):
        """
        初始化生成器
        
        Args:
            dataset_dir: 数据集保存目录
        """
        self.dataset_dir = dataset_dir
        self._create_directories()
    
    def _create_directories(self):
        """创建必要的目录"""
        os.makedirs(self.dataset_dir, exist_ok=True)
    
    def generate_rock_paper_scissors(self) -> ZeroSumGame:
        """
        生成石头剪刀布博弈矩阵
        
        规则：石头胜剪刀，剪刀胜布，布胜石头
        矩阵：行玩家视角，1 表示胜利，-1 表示失败，0 表示平局
        
        Returns:
            ZeroSumGame实例
        """
        payoff_matrix = np.array([
            [ 0, 1, -1], 
            [-1, 0,  1],
            [ 1, -1, 0]
        ])
        
        game = ZeroSumGame(payoff_matrix)
        self.save_game(game, "rock_paper_scissors")
        print("生成石头剪刀布博弈矩阵 (3 x 3)")
        return game
    
    def generate_random_5x5(self) -> ZeroSumGame:
        """
        生成 5 x 5 随机博弈矩阵
        
        Args:
            seed: 随机种子
            
        Returns:
            ZeroSumGame 实例
        """
        np.random.seed(int(time.time()))
        payoff_matrix = np.random.uniform(-5, 5, (5, 5))
        # 保留两位小数
        payoff_matrix = np.round(payoff_matrix, 2)
        
        game = ZeroSumGame(payoff_matrix)
        self.save_game(game, "random_5x5")
        print("生成 5 x 5 随机博弈矩阵")
        return game
    
    def generate_random_10x10(self) -> ZeroSumGame:
        """
        生成 10 x 10 随机博弈矩阵
        
        Args:
            seed: 随机种子
            
        Returns:
            ZeroSumGame 实例
        """
        np.random.seed(int(time.time()))
        payoff_matrix = np.random.uniform(-10, 10, (10, 10))
        # 保留两位小数
        payoff_matrix = np.round(payoff_matrix, 2)
        
        game = ZeroSumGame(payoff_matrix)
        self.save_game(game, "random_10x10")
        print("生成 10 x 10 随机博弈矩阵")
        return game
    
    def save_game(self, game: ZeroSumGame, name: str):
        """
        保存博弈到文件
        
        Args:
            game: ZeroSumGame 实例
            name: 文件名
        """
        filepath = os.path.join(self.dataset_dir, f"{name}.txt")
        # 保留两位小数
        rounded_matrix = np.round(game.payoff_matrix, 2)
        np.savetxt(filepath, rounded_matrix, fmt='%.2f')
        print(f"博弈矩阵保存到: {filepath}")
    
    def generate_all_games(self):
        """生成所有预定义的博弈"""
        print("开始生成博弈数据集...")
        
        games = {}
        games['rock_paper_scissors'] = self.generate_rock_paper_scissors()
        games['random_5x5'] = self.generate_random_5x5()
        games['random_10x10'] = self.generate_random_10x10()
        
        print(f"\n生成完成！共生成 {len(games)} 个博弈，保存在 {self.dataset_dir} 目录")
        return games


def main():
    """主函数：生成所有博弈数据"""
    generator = GameGenerator()
    games = generator.generate_all_games()
    
    # 显示生成的博弈信息
    for name, game in games.items():
        print(f"\n{name}:")
        print(f"  大小: {game.n_rows}x{game.n_cols}")
        print(f"  矩阵:\n{game.payoff_matrix}")


if __name__ == "__main__":
    main() 