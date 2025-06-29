import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from pathlib import Path

def get_dataset(dataset, path, trainsize=50):
    """get ML model data"""
    base_path = Path(path)
    x_train_path = base_path / f"{dataset}_x_train.csv"
    y_train_path = base_path / f"{dataset}_y_train.csv"
    x_test_path = base_path / f"{dataset}_x_test.csv"
    y_test_path = base_path / f"{dataset}_y_test.csv"
    
    if (x_train_path.exists() and y_train_path.exists() and
        x_test_path.exists() and y_test_path.exists()):
        X_train = pd.read_csv(x_train_path).values
        y_train = pd.read_csv(y_train_path).values.flatten()
        X_test = pd.read_csv(x_test_path).values
        y_test = pd.read_csv(y_test_path).values.flatten()
    else:
        print(f"Data not fund: {path}")
        check_folder(path)
        
        if dataset == "iris":
            data = load_iris()
            X = data['data']
            y = data['target']
            X_train, X_test, y_train, y_test = train_test_split(
                X, y, test_size=150-trainsize, random_state=42
            )

        pd.DataFrame(X_train).to_csv(x_train_path, index=False)
        pd.DataFrame(y_train).to_csv(y_train_path, index=False)
        pd.DataFrame(X_test).to_csv(x_test_path, index=False)
        pd.DataFrame(y_test).to_csv(y_test_path, index=False)
        print(f"Data path: {path}")
    return X_train, y_train, X_test, y_test

def check_folder(folder_name):
    """check folder existance and mkdir if not exist"""
    folder_path = Path(folder_name)
    if not folder_path.exists():
        folder_path.mkdir(parents=True, exist_ok=True)
        return True
    return False

if __name__ == '__main__':
    ## iris classfication
    import os
    from sklearn import svm
    from mcSV import mc_sv
    from game import Game
    threshold = 1e-2
    game_type = 'iris'
    num_players = 100
    total_sample_budgets = 1000000
    datapath = './dataset'
    trnX, trnY, tstX, tstY = get_dataset(game_type, datapath, trainsize = 150 - num_players)
    mymodel = svm.SVC(decision_function_shape='ovo', probability=True)
    game = Game(gt = game_type, x_train = trnX, y_train = trnY, x_test = tstX, y_test = tstY,
                model = mymodel, n = num_players)
    mySV = mc_sv(game, total_sample_budget = total_sample_budgets)
    print("My Results:", mySV)
    gt_path = f"./groundTruth/{game_type}_{num_players}.txt"
    if os.path.exists(gt_path):
            try:
                gt_values = np.loadtxt(gt_path)
                print("Ground Truth:", gt_values)
                error = np.abs(mySV - gt_values)
                is_correct = np.abs(error) < threshold
                accuracy = np.mean(is_correct) * 100
                print(f"Accuracy: {accuracy:.2f}%")
            except Exception as e:
                print(f"Accuracy caculation wrong: {e}")
    else:
        print(f"Ground truth not exists: {gt_path}")