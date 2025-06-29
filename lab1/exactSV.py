import numpy as np
Array = np.ndarray
import os
import math
from itertools import chain, combinations
from tqdm import trange
from game import Game

def power_set(iterable):
    """
    生成给定可迭代对象的所有非空子集。
    """
    
    s = list(iterable)
    return chain.from_iterable(combinations(s, r) for r in range(1, len(s) + 1))

def exact_sv(
    game: Game,
    indexes: np.ndarray = np.array([-1])
) -> Array:
    """
    使用基于联盟的方法计算给定博弈中每个玩家的 Shapley 值。

    参数:
        game (Game): 封装好的博弈模型，包含参与人和联盟效用，无需关心具体实现。
        indexes (np.ndarray): 玩家索引数组，默认为 [-1]，表示所有玩家的集合。

    返回:
        np.ndarray: 所有玩家 Shapley 值构成的数组。
    """
    n = game.n # 获取博弈中的玩家数量
    if indexes[0] == -1:
        indexes = np.arange(n) # 将玩家集合设置为 [0, 1, ..., n-1]
    print("Number of player: ", n)
    
    ext_sv = np.zeros(n) # 初始化 Shapley 值数组，初始值为 0
    coalition = indexes
    sets = list(power_set(coalition)) # 生成所有可能的非空子集（联盟）
    num_sets = len(sets) # 计算生成的子集数量
    print(f'Generated {num_sets} Sets')
    
    # 你的代码填写在这里


    return ext_sv

if __name__ == "__main__":
    game_type = 'airport'
    num_players = 25
    game = Game(gt = game_type, n = num_players)
    mySV = exact_sv(game)
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