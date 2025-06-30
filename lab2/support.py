import numpy as np
from itertools import combinations
from nash_verifier import NashVerifier
from scipy.optimize import linprog

class NashSolver:
    
    def __init__(self, payoff_matrix: np.ndarray):
        self.M = payoff_matrix  # 行玩家的收益矩阵
        self.n_rows, self.n_cols = self.M.shape
        
    def find_all_equilibria(self):
        """查找所有纳什均衡（返回支撑集和策略对）"""
        equilibria = []
        
        # 枚举所有可能的支撑集组合
        for row_support in self._powerset(range(self.n_rows)):
            for col_support in self._powerset(range(self.n_cols)):
                if not row_support or not col_support:
                    continue
                
                # 尝试求解该支撑集组合
                sol = self._solve_support(row_support, col_support)
                if sol is not None:
                    x, y, v = sol
                    verifier = NashVerifier(self.M)
                    if verifier.is_equilibrium(x, y, 1e-6):
                        equilibria.append((row_support, col_support, x, y, v))
        
        return equilibria
    
    def _solve_support(self, row_support, col_support):
        """使用线性规划求解带不等式约束的支撑集问题"""
        k, m = len(row_support), len(col_support)
        
        # 变量顺序：[x_1*(1), ..., x_1*(n), x_2*(1), ..., x_2*(m), U_1, U_2]
        n_vars = self.n_rows + self.n_cols + 2
        
        # 我们不需要目标函数，只是找可行解，所以目标函数设为 0
        c = np.zeros(n_vars)
        
        # 等式约束 A_eq * x = b_eq
        eq_constraints = []
        eq_rhs = []
        
        # 1. 行玩家概率和为1：∑_i x_1*(i) = 1
        eq_row = np.zeros(n_vars)
        for i in range(self.n_rows):
            eq_row[i] = 1
        eq_constraints.append(eq_row)
        eq_rhs.append(1)
        
        # 2. 列玩家概率和为1：∑_j x_2*(j) = 1  
        eq_row = np.zeros(n_vars)
        for j in range(self.n_cols):
            eq_row[self.n_rows + j] = 1
        eq_constraints.append(eq_row)
        eq_rhs.append(1)
        
        # 3. 行玩家支撑集内策略收益相等：∑_j u_1(i,j)*x_2*(j) = U_1 for i ∈ S_1
        # 4. 列玩家支撑集内策略收益相等：∑_i u_2(i,j)*x_1*(i) = U_2 for j ∈ S_2  
        # 注意：在零和博弈中 u_2(i,j) = -u_1(i,j) = -M[i,j]
        #--------------------------------------------
        # 请在下方填写你的代码，实现完成后可以将 exception 注释
        #raise NotImplementedError("Constraint 3 and 4 not implemented.")
        for i in row_support:
            eq_row = np.zeros(n_vars)
            for j in range(self.n_cols):
                eq_row[self.n_rows + j] = self.M[i, j]
            eq_row[n_vars - 2] = -1
            eq_constraints.append(eq_row)
            eq_rhs.append(0)

        for j in col_support:
            eq_row = np.zeros(n_vars)
            for i in range(self.n_rows):
                eq_row[i] = -self.M[i, j]
            eq_row[n_vars - 1] = -1
            eq_constraints.append(eq_row)
            eq_rhs.append(0)
        
        #--------------------------------------------
        
        # 5. 支撑集外策略概率为0
        for i in range(self.n_rows):
            if i not in row_support:
                eq_row = np.zeros(n_vars)
                eq_row[i] = 1
                eq_constraints.append(eq_row)
                eq_rhs.append(0)
                
        for j in range(self.n_cols):
            if j not in col_support:
                eq_row = np.zeros(n_vars)
                eq_row[self.n_rows + j] = 1
                eq_constraints.append(eq_row)
                eq_rhs.append(0)
        
        A_eq = np.array(eq_constraints) if eq_constraints else None
        b_eq = np.array(eq_rhs) if eq_rhs else None
        
        # 不等式约束 A_ub * x <= b_ub
        ineq_constraints = []
        ineq_rhs = []
        
        # 6. 行玩家支撑集外策略收益不超过支撑集内：∑_j u_1(i,j)*x_2*(j) ≤ U_1 for i ∉ S_1
        # 7. 列玩家支撑集外策略收益不超过支撑集内：∑_i u_2(i,j)*x_1*(i) ≤ U_2 for j ∉ S_2
        #--------------------------------------------
        # 请在下方填写你的代码，实现完成后可以将 exception 注释
        # raise NotImplementedError("Constraint 6 and 7 not implemented.")
        for i in range(self.n_rows):
            if i not in row_support:
                ineq_row = np.zeros(n_vars)
                for j in range(self.n_cols):
                    ineq_row[self.n_rows + j] = self.M[i, j]
                ineq_row[n_vars - 2] = -1
                ineq_constraints.append(ineq_row)
                ineq_rhs.append(0)

        for j in range(self.n_cols):
            if j not in col_support:
                ineq_row = np.zeros(n_vars)
                for i in range(self.n_rows):
                    ineq_row[i] = -self.M[i, j]
                ineq_row[n_vars - 1] = -1
                ineq_constraints.append(ineq_row)
                ineq_rhs.append(0)

        #--------------------------------------------

        A_ub = np.array(ineq_constraints) if ineq_constraints else None
        b_ub = np.array(ineq_rhs) if ineq_rhs else None
        
        bounds = []
        for i in range(self.n_rows + self.n_cols):
            bounds.append((0, 1))  # 概率非负
        bounds.append((None, None))  # U_1 无界
        bounds.append((None, None))  # U_2 无界
        
        try:
            # 使用线性规划求解
            result = linprog(c, A_eq=A_eq, b_eq=b_eq, A_ub=A_ub, b_ub=b_ub, 
                           bounds=bounds, method='highs')
            
            if result.success:
                x_strat = result.x[:self.n_rows]
                y_strat = result.x[self.n_rows:self.n_rows + self.n_cols]
                
                # 计算均衡收益
                v = x_strat @ self.M @ y_strat
                
                return x_strat, y_strat, v
            else:
                return None
                
        except Exception:
            return None

    
    @staticmethod
    def _powerset(s):
        """生成所有非空子集"""
        return sum(([tuple(comb) for comb in combinations(s, r)] 
                  for r in range(1, len(s)+1)), [])