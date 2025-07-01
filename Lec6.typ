#set document(
  title: "数据要素交易基础",
  author: "forliage",
)

// --- 页面与字体设置 ---
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.2cm),
  // 页眉：显示课程标题
  header: align(center)[
    #text(10pt, fill: gray)[数据要素交易基础]
    #line(length: 100%, stroke: 0.5pt + gray)
  ],
  // 页脚：显示页码
  //footer: align(right)[#counter(page)]
)

// 设置中英文基础字体，保证跨平台兼容性
// 如果你有特定的字体，可以替换 "New Computer Modern" 和 "Noto Serif CJK SC"
// 比如 Windows 用户可以使用 "STSong" "SimSun" 等
#set text(
  font: ("New Computer Modern", "Noto Serif CJK SC"),
  size: 11pt,
  lang: "zh",
)


// --- 颜色定义 ---
#let primary_color = rgb("#007A7A") // 深青色 (Teal)
#let accent_color = rgb("#FFB81C")  // 亮黄色 (Amber)
#let text_color = rgb("#333333")    // 深灰色
#let bg_color = rgb("#F5F7F7")      // 极浅的背景灰

#set text(fill: text_color)

// --- 标题样式定义 ---
// 一级标题
#show heading.where(level: 1): it => {
  v(1.8em, weak: true) // 标题前的垂直间距
  let title_text = text(18pt, weight: "bold", primary_color, it.body)
  [
    #title_text
    #line(length: 100%, stroke: 1pt + primary_color)
  ]
  v(1em, weak: true) // 标题后的垂直间距
}

// 二级标题
#show heading.where(level: 2): it => {
  v(1.2em, weak: true)
  // 在标题前加一个装饰性的方块
  rect(width: 6pt, height: 6pt, fill: accent_color)
  h(6pt)
  text(14pt, weight: "bold", it.body)
  v(0.6em, weak: true)
}

// --- 自定义笔记模块 ---

// 定义模块
#let definition(title, body) = {
  block(
    stroke: (left: 2pt + primary_color),
    radius: 3pt,
    inset: 10pt,
    width: 100%,
    breakable: true,
  )[
    #text(weight: "bold")[定义：#title]
    \
    #body
  ]
}

// 定理模块 (自动编号)
#let theorem_counter = counter("theorem")
#let theorem(title, body) = {
  theorem_counter.step()
  block(
    fill: bg_color,
    radius: 3pt,
    inset: 10pt,
    width: 100%,
    breakable: true,
  )[
    #text(weight: "bold")[定理 #theorem_counter.display("1")：#title]
    \
    #body
  ]
}

// 示例模块
#let example(title, body) = {
  v(0.5em)
  block(
    stroke: (top: 1pt + accent_color.lighten(20%)),
    inset: (top: 10pt, bottom: 10pt, x: 8pt),
    width: 100%,
    breakable: true,
  )[
    #text(weight: "bold", style: "italic", accent_color)[示例：#title]
    \
    #body
  ]
  v(0.5em)
}

// 关键点模块
#let keypoint(body) = {
  block(
    fill: accent_color.lighten(80%),
    radius: 4pt,
    inset: 10pt,
    width: 100%,
    breakable: true,
  )[
    *💡 关键点* \
    #body
  ]
}

// 重要公式模块 (自动编号)
#let formula_counter = counter("formula")
#let formula(eq) = {
  formula_counter.step()
  align(center, $ #eq $)
  align(right, text(9pt, fill: gray)[(#formula_counter.display())])
  v(0.5em)
}

// --- 标题页函数 ---
#let title_page() = {
  // 禁用当前页的页眉页脚
  set page(header: none, footer: none)
  align(center + horizon)[
    #v(3cm)
    #text(28pt, weight: "bold")[数据要素交易基础]
    #v(1cm)
    #text(16pt)[Course Notes]
    #v(2cm)
    #line(length: 30%, stroke: 0.5pt)
    #v(2cm)
    #grid(
      columns: (1fr, 2fr),
      gutter: 1em,
      [讲师：], [刘金飞],
      [学期：], [2025 年暑],
      [学生：], [forliage],
    )
    #v(6cm)
  ]
  // 恢复页眉页脚
  pagebreak()
  set page(
    header: align(center)[#text(10pt, fill: gray)[数据要素交易基础]#line(length: 100%, stroke: 0.5pt + gray)],
    footer: align(right)[#counter(page).display("1 / 1")]
  )
  counter(page).update(1) // 重置页码为1
}

= Lecture 6: 多臂老虎机算法基础与应用

== 一、随机多臂老虎机

=== 1.一般的机器学习任务

常见：Image recognition, Preference learning for recommendations, Speech recognition, Next token/word prediction(for language models)

以上都是基于模式识别的学习问题(recognition-based learning problems);
- 学习环境通常是给定的：输入图片/语言...输出标签；
- 通常使用监督学习：学习特征到标签的映射。
本讲介绍的是基于决策的学习问题(decision-based learning problems);
- 学习环境通常是动态的；
- 通过决策过程中获得的奖励/代价学习到最优策略(AlphaGo)；
- 强化学习(reinforcement learning)；
- 多臂老虎机：无状态转移的强化学习。

=== 2.多臂老虎机问题：引入
一个赌鬼要玩多臂老虎机，摆在他面前有$K$个臂(Arms)或动作选择(Actions)，每一轮游戏中，他要选择拉动一个臂并会获得一个随机奖励(reward)(这一随机奖励来源于一个赌场设定好的分布，但赌鬼一开始不知道这一分布)。如果总共玩$T$轮，他该如何最大化奖励？
$ r_i ~ D_i ("for " i = 1,..,k) $
其它场景：新闻网站(推荐系统)、动态定价、投资组合///

问题本质：explore and exploit。例如新闻网站的推荐，可以先尝试几次随机推荐探索用户的喜好，
然后利用这几次尝试学习到的结果做出比较准确的推荐。

=== 3.基本概念
根据反馈类型分类：
- 完全反馈(full feedback)：能看见所有臂的奖励，例如投资组合股票的涨跌；
- 部分反馈(partial feedback)：能看见部分臂的奖励，例如动态定价中任何更低(高)价格都被接受(拒绝)；
- 老虎机反馈(bandit feedback)：只能看见选择的臂的奖励，例如新闻网站上该新闻是否被用户点击。

根据奖励类型分类：
- 随机奖励/IID奖励：玩家或者的奖励随机曲子一个未知概率分布
- 对抗性奖励：奖励可以任意，能由一个"对手"有针对性的选择

=== 4.随机多臂老虎机问题模型

在每一步$t=1,2,...,T$中：
+ 玩家选择一个臂$a_t in A = {a_1,...,a_K}$;
+ 玩家获得该臂对应的随机奖励$r_t ~ R(a_t) (r_t in [0,1])$；
+ 玩家依据过往轮次的奖励情况调整选择策略，实现奖励最大。

说明：
- 奖励分布的均值记为$mu(a_k)= bb(E)[R(a_k)], k in [K]$；
- 最优臂$a^ast$的奖励均值$mu^ast = max_(a in A) mu(a)$；
- 奖励均值差异$Delta (a) = mu^ast - mu(a)$。 

=== 5.遗憾分析
我们需要设计MAB算法实现最大化奖励，实际上就是找最优臂。那么，分析MAB算法的性能就是在分析算法能否找到最优臂。我们用遗憾(regret)来度量实际选择和最优选择的差异。

定义：
+ 伪遗憾(pseudo-regret)：$ R(T)= sum_(t=1)^T (mu^ast - mu(a_t)) = mu^ast dot T - sum_(t=1)^T mu(a_t) $
+ 期望遗憾(expected regret):$bb(E)[R(T)]$。

即伪遗憾就是选择最优臂的期望收益减去实际收益，期望遗憾是伪遗憾的期望(玩家策略可能存在随机性，因此$mu(a_t)$可能是随机变量)。显然，最大化奖励的目标可以等价为最小化遗憾的目标。

在MAB问题中，wine吧常常关注算法遗憾界(regret bound)。一个好的遗憾界是次线性的(sub-linear)，这意味着算法能逐渐学到最优臂，即$ ("regret bound")/T -> 0, T->infinity $

=== 6.Hoeffding不等式

假设$X_1,X_2,...,X_n$是$[0,1]$上的独立随机变量，样本均值为$overline(X_n)= 1/n sum_(i=1)^n X_i, mu = bb(E)[overline(X_n)]$。对于任意$epsilon >0$有：
$ bb(P)( |mu - overline(X_n)| >= epsilon)<= 2 exp(-2 n epsilon^2) $

该不等式属于集中不等式(concentration inequalities)，直观上来说$bb(P)(|mu - overline(X_n)|<= "small") >= 1 - "small"$，即样本均值与实际均值的差距很小的概率是很大的，并且随机变量个数越多($N$越大)差距大的概率越小。

与多臂老虎机问题的关联：将$X_1,...,X_n$视为选择一个臂$n$次得到的$n$个奖励，这一不等式表明，当$n$很大时，采样出的奖励均值和臂的真实均值非常接近的。

称$[mu-epsilon,mu+epsilon]$是置信区间(confidence interval)，$epsilon$是置信半径(confidence radius)。若令$epsilon=sqrt((alpha log T)/n)$，则有
$ bb(P)(|mu-overline(X_n)|>=epsilon)=bb(P)(|mu-overline(X_n)|>= sqrt((alpha log T)/n))<=2 T^(-2 alpha), forall alpha > 0 $
在接下来的讨论中一般取$alpha=2$

=== 7.贪心算法
为了找到那个最好的臂，一个朴素的解决思路是，将所有臂都尝试一遍，然后选择表现最好的臂，并在后续的时间步中保持这种选择。贪心算法就是这么一种算法，它采用"完全偏向利用"的策略，其基本策略是“始终选择当前估计奖励最高的臂，并利用历史经验更新对每个臂的奖励估计值。

#block(
  stroke: (top: 1pt, bottom: 1pt), // 设置上下边框线
  inset: 8pt, // 设置内部留白
  width: 100% // 宽度占满
)[
  #grid(
    columns: (auto, 1fr), // 第一列（行号）宽度自适应，第二列（内容）占满
    column-gutter: 1em,   // 列间距
    row-gutter: 0.65em,   // 行间距

    // 第 1 行
    "1:", [探索阶段：将每个臂各尝试 $N$ 次],

    // 第 2 行
    "2:", [利用阶段：],

    // 第 3 行 (一级缩进)
    "3:", [#h(2em) *for* $t > K N$ *do*],

    // 第 4 行 (二级缩进)
    "4:", [#h(4em) 选择平均奖励最高的臂 $hat(a) = arg max_a Q_t(a)$],

    // 第 5 行 (二级缩进)
    "5:", [
      #h(4em) 观察奖励 $r_t$, $N_(t+1)(hat(a)) = N_t(hat(a)) + 1$,
      $Q_(t+1)(hat(a)) = Q_t(hat(a)) + (r_t - Q_t(hat(a))) / (N_(t+1)(hat(a)))$
    ],
    
    // 第 6 行 (一级缩进)
    "6:", [#h(2em) *end for*],
  )
]

注意$N_t (hat(a))$的含义是第$t$轮前$hat(a)$被选过的次数，
$ Q_(t+1) (hat(a)) = Q_t (hat(a)) + (r_t - Q_t (hat(a)))/(N_(t+1) (hat(a))) $
则是在更新$hat(a)$的平均奖励。第$t$轮未被选中的臂对应的$N$和$Q$值不变。

=== 8.贪心算法的遗憾分析

定理：贪心算法的遗憾界为$O(T^(2/3) (K log T)^(1/3))$。 

首先考虑$K=2$的情况，即只有两个臂。遗憾产生当且仅当选择了次优臂$a != a^ast$。显然，探索阶段的遗憾为
$ R("exploration") <= N $
对于利用阶段，分为两种情况考虑(通常的分析套路)： 
+ 事件$E$：所有臂$a$均满足$|mu(a) - Q(a)|<= sqrt((2 log T)/T)$，即两个臂的采样期望奖励$Q(a)$与真实期望$mu(a)$间差距都不大的情况；
+ 事件$overline(E)$：事件$E$的补集。

则有：
$
& bb(E)[R("exploitation")] \
& <= bb(E)[R("exploitation") | E] times bb(P)(E) + bb(E)[R("exploitation") | overline(E)] times bb(P)(overline(E)) \
& <= bb(E)[R("exploitation") | E] + T times O(1/T^4)
$

其中$O(1/(T^4))$来源于
$ bb(P)(|mu(a) - Q(a)|<= sqrt((2 log T)/N))>= 1 - 2 T^(-4) $
由此可以看出，如上拆分成两个事件的目标是说明大概率发生的事件遗憾
小，遗憾大的事件发生概率小，综合二者可以证明遗憾是比较小的。

记$"rad"=sqrt((2 log T)/N)$，在事件$E$下产生遗憾时，有
$ mu(a) + "rad" >= Q(a)>Q(a^ast) >= mu(a^ast) - "rad" $
其中首尾两个$>=$来源于$E$的定义，中间的$>$来源于此时产生了遗憾，即最好的臂的采样期望比次优的臂小。整理得$mu(a^ast) - mu(a) <= 2 "rad"$。那么
$
& bb(E)[R("exploitation")] \
& <= bb(E)[R("exploitation") | E] + T times O(1/(T^4)) \
& <= (T - 2 N) dot 2 "rad" + O(1/(T^3))
$

综合探索和利用的遗憾可得$bb(E)[R(T)] <= N + 2 "rad" T + O(1/(T^3))$。若令$N=T^(2/3) (log T)^(1/3)$，则有$bb(E)[R(T)]<= O(T^(2/3) (log T)^(1/3))$。 

下面考虑$K>2$的情况，探索阶段的遗憾为
$ R("exploitation")<= N(K-1) $
利用阶段的遗憾为
$
& bb(E)[R("exploitation")] \
& <= bb(E)[R("exploitation") | E] times bb(P)(E) + bb(E)[R("exploitation") | overline(E)] times bb(P)(overline(E)) \ 
& <= (T - N K) dot 2 "rad" + O(1/(T^3)) 
$

综合探索和利用的遗憾可得$bb(E)[R(T)]<= N K + 2 "rad" T+ O(1/(T^3))$。若令 
$N = (T/K)^(2/3) dot O(log T)^(1/3)$，则有$bb(E)[R(T)]<= O(T^(2/3) (K log T)^(1/3))$ 

=== 8.$epsilon$-贪心算法 

回想上面的贪心算法存在两个问题：
- “探索”阶段的尝试带来遗憾；
- “利用”阶段陷于局部最优带来遗憾。

为了解决这两个问题，$epsilon$-贪心算法引入了随机性，在“探索”与“利用”之间实现了较好的权衡；
- 其核心思想是：以$1- epsilon$的概率选择当前已在最优的臂$a^prime = arg max_(a) Q_t (a)$，以$epsilon$的概率随机选择一个臂；
- 前一步代表对当前知识的“利用”，后一步代表对可能最优的“探索”，从而避免陷入局部最优；
- 通过调整$epsilon (0<= epsilon <= 1)$的值，可以控制探索和利用之间的平衡；较小的$epsilon$值倾向于更多的利用，而较大的$epsilon$值倾向于更多的探索；通常而言会将$epsilon$设置成一个较小的值。

#block(
  stroke: (top: 1pt, bottom: 1pt), // 设置上下边框线
  inset: 8pt, // 设置内部留白
  width: 100% // 宽度占满
)[
  #grid(
    columns: (auto, 1fr), // 第一列宽度自适应，第二列占满剩余空间
    column-gutter: 1em,   // 两列之间的间距
    row-gutter: 0.65em,   // 行间距

    // 第 1 行
    "1:", [*for* $t = 1, 2, ..., T$ *do*],
    
    // 第 2 行 (缩进)
    "2:", [#h(2em) 以 $epsilon_t$ 的概率探索：随机选择一个臂],
    
    // 第 3 行 (缩进)
    "3:", [#h(2em) 以 $(1 - epsilon_t)$ 的概率利用：选择 $a_t = arg max_a Q_t(a)$],
    
    // 第 4 行 (缩进)
    "4:", [
      #h(2em) 观察奖励 $r_t$, $N_(t+1)(hat(a)) = N_t(hat(a)) + 1$,
      $Q_(t+1)(hat(a)) = Q_t(hat(a)) + (r_t - Q_t(hat(a))) / (N_(t+1)(hat(a)))$
    ],

    // 第 5 行
    "5:", [*end for*],
  )
]

通过选择合适的$epsilon$值，可以证明$epsilon$-贪心算法的遗憾上界：

定理：令$epsilon_t = t^(- 1/3) (K log t)^(1/3)$，$epsilon$-贪心算法的遗憾界为$O(T^(2/3) (K log T)^(1/3))$。 （定理的证明在hw1.typ中）

该算法的优势是简单易实现，并且可以通过调整$epsilon$灵活控制探索与利用。

=== 9.上置信界算法

$epsilon$-贪心策略存在一个问题：虽然每个动作都有被选择的概率，但是这种选择太过于随机，导致最优臂被访问的概率较低，这并不能有助于智能体很大概率的发现最优选择，上置信界算法（upper confidence bound，UCB）很好地改进了这一点。

UCB 算法是多臂赌博机问题中一种经典的基于置信区间的探索-利用策略。其核心思想是为每个臂的奖励估计构建一个置信区间上界，选择上界最大的臂，从而在探索和利用之间自动平衡。

#block(
  stroke: (top: 1pt, bottom: 1pt), // 设置上下边框线
  inset: 8pt, // 设置内部留白
  width: 100% // 宽度占满
)[
  #grid(
    columns: (auto, 1fr), // 列定义：第一列宽度自适应，第二列占满
    column-gutter: 1em,   // 列间距
    row-gutter: 0.65em,   // 行间距

    // 第 1 行 (顶层)
    "1:", [对于每个候选项 $k=1, ..., K$, 令 $Q_1(a_k) = 0, N_1(a_k) = 0$],

    // 第 2 行 (顶层)
    "2:", [*for* $t = 1, ..., T$ *do*],

    // 第 3 行 (一级缩进)
    "3:", [#h(2em) *if* $t <= K$ *then*],

    // 第 4 行 (二级缩进)
    "4:", [#h(4em) 初始化顺序选择每个臂],

    // 第 5 行 (一级缩进)
    "5:", [#h(2em) *else*],

    // 第 6 行 (二级缩进)
    "6:", [#h(4em) 选择 $a_t = arg max_a (Q_t(a) + sqrt((2 ln t)/N_t(a)))$],

    // 第 7 行 (一级缩进)
    "7:", [#h(2em) *end if*],
    
    // 第 8 行 (一级缩进)
    "8:", [
      #h(2em) 观察奖励 $r_t$, $N_(t+1)(a_t) = N_t(a_t) + 1$,
      $Q_(t+1)(a_t) = Q_t(a_t) + (r_t - Q_t(a_t))/(N_(t+1)(a_t))$
    ],

    // 第 9 行 (顶层)
    "9:", [*end for*],
  )
]

简而言之，UCB 的算法流程是：首先将每一个候选臂都选择一遍，作为初始化；然后在后续的时间步中，选择奖励均值估计量的上置信界最大的臂，其中均值估计量的上置信界定义为
$ Q_t (a) + sqrt((2 ln t)/(N_t (a))) $
最后更新被选中的臂的相关参数。其中上置信界的直观理解是：
- 上置信界的前一项$Q_t (a)$代表臂的估计奖励，这个值越大说明对应臂的历史表现越好；
- 后一项$sqrt((2 ln t)/(N_t (a)))$是置信区间的半径，其会随着选择次数的增加而变小，并且该值越大则说明估计的不确定性越大，因此能过鼓励玩家尝试较少被选择的臂，避免陷入次优；
- 因此，选择上置信界最大的臂有利于偏向于选择表现较好或是较少选择的臂，从而算法能够逐渐收敛到最优臂。

总而言之。UCB 算法同时考虑了估计奖励与不确定性，较好的平衡了探索与利用，也可以得到更好的遗憾界：

定理：UCB算法的遗憾界为$O(sqrt(K T log T))$。 

我们来补充此定理的证明：我们先来分析在什么情况下一个次优臂$i$(即$Delta_i > 0$)会在第$t$轮被选择。根据UCB的规则，如果臂$i$被选中，那么它的UCB值必须大于等于最优臂$a^ast$的UCB值：
$ hat(mu)_(i,N_i (t-1)) + sqrt((2 log t)/(N_i (t-1))) >= hat(mu)_(a^ast, N_(a^ast) (t-1)) + sqrt((2 log t) / (N_(a^ast) (t-1))) $
为了使这个不等式成立，以下三种情况中至少有一种必须发生：
+ 最优臂被低估 (Pessimistic estimate for optimal arm): 最优臂的经验平均值远低于其真实平均值。 $ hat(mu)_(a^ast, N_(a^ast) (t-1)) < mu^ast - sqrt((2 log t)/(N_(a^ast) (t-1))) $
+ 次优臂被高估 (Optimistic estimate for sub-optimal arm): 次优臂$i$的经验平均值远高于其真实平均值。 $ hat(mu)_(a^ast, N_(a^ast) (t-1)) < mu^ast + sqrt((2 log t)/(N_(i) (t-1))) $
+ 臂$i$的拉动次数还不够多 (Arm $i$ is not pulled enough times): 此时置信区间仍然很大，导致其真实均值和最优均值的差距被置信区间覆盖。 $ mu^ast - mu_i <= 2 sqrt((2 log t)/(N_i (t-1))) $

假设三种情况都没发生，将他们结合起来得到：
$ "UCB"_(a^ast) (t) = hat(mu)_(a^ast, N_(a^ast) (t-1)) + sqrt((2 log t)/(N_(a^ast) (t-1))) >= mu^ast $
$ "UCB"_i (t) = hat(mu)_(i, N_i (t-1)) + sqrt((2 log t)/(N_i (t-1))) <= mu_i + 2 sqrt((2 log t)/(N_i (t-1)))<  mu^ast $
这就得出了$"UCB"_i (t) < "UCB"_(a^ast) (t)$，与臂$i$被选中的前提相矛盾。因此，只要臂$i$被选中，上述三种情况必有其一为真。

现在我们来分析这三种情况发生的次数：

- 对于情况 3，我们对其进行代数变换：$ Delta_i <= 2 sqrt((2 log t)/(N_i (t-1))) ==>Delta_i^2 <= (8 log t)/(N_i (t-1)) ==> N_i (t-1)<= (8 log t)/(Delta_i^2) $ 由于$t<=T$，所以臂$i$因为这种情况被选择的次数不会超过$(8 log T)/(Delta_i^2)$。我们称这个阈值为$l_i = ceil((8 log T)/(Delta_i^2))$。
- 对于情况 1 和 2，我们可以使用 霍夫丁不等式 (Hoeffding's Inequality) 来约束它们发生的概率。令$epsilon = sqrt((2 log t)/s)$，我们得到：$ P(hat(x_s) - x > sqrt((2 log t)/s))<= e^(-2 s ((2 log t)/s))= e^(-4 log t) = t^(-4) $ 这个概率非常小。臂$i$在$t$时刻因为情况 1 或 2 被选择的次数，其期望可以被一个很小的、可求和的序列约束。在所有轮次中，由于这两种“坏事件”而选择臂$i$的总次数的期望是一个常数。例如，$sum_(t=1)^infinity t^(-4)= (pi^4)/(90) - 1$

综合来看，臂$i$被选择的总次数的期望$bb(E) [N_i (T)]$主要由情况 3 决定。因此，我们可以得到一个上界：
$ bb(E)[N_i (T)] <= (8 log T)/(Delta_i^2) + C $
其中$C$是一个不依赖于$T$的小常数（来自初始拉动和坏事件的次数）。在分析渐近行为时，我们主要关注$log T$项。

现在我们有了每个次优臂被选择次数的期望上界。我们回到总遗憾的公式，并使用 柯西-施瓦茨不等式 (Cauchy-Schwarz Inequality)。

总遗憾的期望为$R_T = sum_(i=1)^K bb(E)[N_i (T)] Delta_i$。
$ R_T^2 = (sum_(i=1)^K bb(E)[N_i (T)]Delta_i)^2 = (sum_(i=1)^K sqrt(bb(E)[N_i (T)]) dot sqrt(bb(E) [N_i (T)]) Delta_i)^2 $
根据柯西-施瓦茨不等式得到：
$ R_T^2 <= (sum_(i=1)^K (sqrt(bb(E)[N_i (T)]))^2)dot (sum_(i=1)^K (sqrt(bb(E) [N_i (T)])Delta_i)^2) $
$ R_T^2<=(sum_(i=1)^K bb(E)[N_i (T)])dot (sum_(i=1)^K bb(E)[N_i (T)] Delta_i^2) $

第一项： 所有臂被选择次数的期望之和就是总试验次数$T$:
$ sum_(i=1)^K bb(E) [N_i (T)] = bb(E) [sum_(i=1)^K N_i (T)] = T $
第二项： 我们使用第一步得到的结论$bb(E)[N_i (T)]<= (8 log T)/(Delta_i^2) +C$。
$ sum_(i=1)^K bb(E)[N_i (T)]Delta_i^2 = bb(E)[N_(a^ast)]Delta_(a^ast)^2 + sum_(i!= a^ast) bb(E)[N_i (T)]Delta_i^2 $
由于$Delta_(a^ast)=0$，第一项为0.由于总共有$K-1$个次优臂，并且$Delta_i in [0,1]$，所以$Delta_i^2 <= 1$。
$ <= (K-1)(8 log T) + C sum_(i!= a^ast) Delta_i^2 <= 8 K log T + C K $
所以，这一项的上界是$O(K log T)$。 
将这两项的结果代入得到：
$ R_T^2 <= T dot O(K log T)=O(K T log T) $
由此得到：
$ R_T <= O(sqrt(K T log T)) $

=== 10.汤普森采样算法

== 二、对抗性多臂老虎机

== 三、多臂老虎机的应用