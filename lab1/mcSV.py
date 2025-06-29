import numpy as np
Array = np.ndarray
import time
import os
from tqdm import trange
from game import Game

def mc_sv(
    game: Game,
    total_sample_budget: int = 2000,
    indexes: np.ndarray = np.array([-1])
) -> Array:
    """
    使用蒙特卡洛方法计算给定博弈中每个玩家的 Shapley 值。蒙特卡洛方法通过随机采样玩家排列来估算 Shapley 值，适用于玩家数量较多时的近似计算。每次采样中，计算玩家的边际贡献并累加，最终取平均值。

    参数:
        game (Game): 封装好的博弈模型，包含参与人和联盟效用，无需关心具体实现。
        total_sample_budget (int): 总采样预算，除以玩家数就是采样的排列数。
        indexes (np.ndarray): 玩家索引数组，默认为 [-1]，表示所有玩家的集合。

    返回:
        np.ndarray: 所有玩家 Shapley 值构成的数组。
    """
    n = game.n
    sv = np.zeros(n)
    if indexes[0] == -1:
        indexes = np.arange(n)
    n_samples = total_sample_budget // n # 计算采样的排列数

    for _ in trange(n_samples): # 遍历每次采样，使用 tqdm 显示进度条
        np.random.shuffle(indexes) # 随机打乱玩家索引，生成随机排列
        
        # 你的代码填写在这里，目标是对当前采样到的排列中的每个玩家计算边际贡献，并累加进 Shapley 值中
        
    
    return np.array(list(sv/n_samples))


if __name__ == "__main__":
    game_type = 'airport'
    num_players = 25
    total_sample_budgets = 40000000
    game = Game(gt = game_type, n = num_players)
    mySV = mc_sv(game, total_sample_budget = total_sample_budgets)
    gt_path = f"./groundTruth/{game_type}_{num_players}.txt"
    if os.path.exists(gt_path):
        try:
            gt_values = np.loadtxt(gt_path)
            print("My Results:", mySV)
            print("Ground Truth:", gt_values)
            error = np.abs(mySV - gt_values)
            threshold = 1e-2
            is_correct = np.abs(error) < threshold
            accuracy = np.mean(is_correct) * 100
            print(f"Accuracy: {accuracy:.2f}%")
        except Exception as e:
            print(f"Accuracy caculation wrong: {e}")
    else:
        print(f"Ground truth not exists: {gt_path}")