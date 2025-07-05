import numpy as np
from sklearn import metrics

class Game:
    def __init__(self,
                 gt,
                 x_train=None,
                 y_train=None,
                 x_test=None,
                 y_test=None,
                 model=None, 
                 n=None):
        self.gt = gt
        self.x_train = x_train
        self.y_train = y_train
        self.x_test = x_test
        self.y_test = y_test
        self.model = model
        self.null = 0
        # For games
        if gt == 'voting':
            self.w = [
                45, 41, 27, 26, 26, 25, 21, 17, 17, 14, 13, 13, 12, 12, 12,
                11, 10, 10, 10, 10, 9, 9, 9, 9, 8, 8, 7, 7, 7, 7, 6, 6, 6,
                6, 5, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3
            ]
            self.n = len(self.w)
            self.hw = np.sum(self.w) / 2
            self.w = np.array(self.w)
        elif gt == 'airport':
            self.w = [i for i in range(1, n+1)]
            self.n = len(self.w)
            self.w = np.array(self.w)
        elif gt == "iris":
            self.n = len(self.y_train)
            # print(self.x_train.shape, self.y_train.shape)
        else:
            print("game name init error")

    def get_utility(self, x):
        """Evaluate the coalition utility.
        """
        if len(x) == 0:
            return self.null
        if self.gt == 'voting':
            r = np.sum(self.w[x])
            return 1 if r > self.hw else 0
        elif self.gt == 'airport':
            r = np.max(self.w[x])
            return r
        elif self.gt == "iris":
            temp_x, temp_y = self.x_train[x], self.y_train[x]
            single_pred_label = (True if len(np.unique(temp_y)) == 1 else False)
            # one class classfication condition

            if single_pred_label:
                y_pred = [temp_y[0]] * len(self.y_test)
            else:
                self.model.fit(temp_x, temp_y)
                y_pred = self.model.predict(self.x_test)
            return metrics.accuracy_score(self.y_test, y_pred, normalize=True)
        else:
            print("game name error")
            return -1