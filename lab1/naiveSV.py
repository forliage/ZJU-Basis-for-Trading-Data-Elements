import numpy as np
from game import Game
Array = np.ndarray
from itertools import permutations
from tqdm import trange
import os

def exact_sv(
    game: Game,
    indexes: np.ndarray = np.array([-1])
) -> Array:
    """
    使用基于排列的方法计算给定博弈中每个玩家的 Shapley 值。

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
    coalition = indexes # 将玩家索引赋值给 coalition
    perms = list(permutations(coalition)) # 生成所有玩家排列的列表
    num_perms = len(perms) # 计算排列的总数
    print(f'Generated {num_perms} permutations')
    
    for perm in trange(num_perms): # 遍历每一个排列，使用 tqdm 显示进度条
        perm_list = list(perms[perm]) # 获取当前排列并转换为列表
        
        # 后续要计算边际贡献 u(P_i(\sigma) \cup \{i\}) - u(P_i(\sigma))，首先将第一个被减的效用初始化为空集联盟的效用 $u(\varnothing)$
        prev_utility = game.get_utility(np.array(list([])))

        # 在每个排列中把每个玩家的边际贡献都计算出来
        for i in range(n):
            current_player = perm_list[i] # 获取当前玩家
            current_set = set(perm_list[:i+1]) # 获取当前玩家及之前玩家组成的集合
            current_utility = game.get_utility(np.array(list(current_set))) # 取出当前集合的效用值
            marginal = current_utility - prev_utility # 计算当前玩家的边际贡献
            ext_sv[current_player] += marginal # 将边际贡献累加到当前玩家的 Shapley 值中
            prev_utility = current_utility # 更新前一个效用值为当前效用值
    
    ext_sv = ext_sv  / num_perms # 将循环累加的结果除以排列总数，得到 Shapley 值
    return ext_sv

if __name__ == "__main__":
    game_type = 'airport'
    num_players = 10
    game = Game(gt = game_type, n = num_players)
    mySV = exact_sv(game)
    gt_path = f"./groundTruth/{game_type}.txt"
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