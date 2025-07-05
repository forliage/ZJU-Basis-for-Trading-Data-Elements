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

= Lecture 8：最优机制

== 一、虚拟福利最大值

=== 1.基本模型

考虑单物品情况，即一个卖家有一个不可分割的物品待出售；
- 与此前单物品讨论一致，有$n$个潜在买家（竞拍者）$N={1,2,...,n}$；
- 每个买家$i$对物品有一个心理价位$t_i$是不完全信息；
   - 其连续先验概率密度$f_i: [a_i, b_i] -> bb(R)^+$是共同知识，且$f_i (t_i) > 0$对所有$t_i in [a_i, b_i]$成立；
   - 记$T$为所有参与人可能的估值组合，即 $ T = [a_1, b_1] times [a_2, b_2] times ... times [a_n,b_n] $
- 假定不同买家的估值分布是相互独立的（但不需要同分布）；
   - 故在$T$上估值的联合密度函数是$f(t) = product_(i=1)^n f_i (t_i)$
   - 按照惯例记$f_(-i) (t_(-i)) = product_(j in N, j != i) f_j (t_j) $
- 此外，为了讨论方便，卖家对物品的估值$t_0 = 0$是共同知识。

=== 2.BIC 迈尔森引理

根据显示原理，只需要考虑激励相容的直接机制，即所有买家如实报告自己的估值的机制。在最优机制的讨论中，如实报告类型不一定是占优策略均衡，而是贝叶斯纳什均衡，等价条件与 DSIC 时不一定相同，故需要给出 BIC 版本的迈尔森引理。

为给出 BIC 迈尔森引理，需要一些准备工作。假定拍卖机制的分配规则和支付规则为$(x,p)$，考虑事中阶段，即参与人知道自己的估值，对他人估值是不完全信息的阶段。为了讨论 BIC 的条件，应首先写出效用函数。

由于考虑的是贝叶斯纳什均衡，因此应当考虑其他参与人都如实报告自己估值时，即$b_(-i) = t_(-i)$时，估值为$t_i$的竞拍者$i$报告$t_i^prime$的期望效用
$ U_i (t_i^prime) = integral_(T_(-i)) (t_i dot x_i (t_i^prime, t_(-i))) f_(-i) (t_(-i)) d t_(-i) $
理解这一表达式：买家效用为他的估值$t_i$乘以物品分配概率$x_i (t_i^prime, t_(-i))$，减去支付$p_i (t_i^prime, t_(-i))$，然而买家不能确定其他买家真实估值，因此还需要根据先验分布对其他人的估值求期望。因此 BIC 的条件就是$U_i (t_i) >= U_i (t_i^prime)$对所有$i in N$和$t_i^prime in [a_i, b_i]$成立。

然而这一$U_i$的表达式的确看起来非常不友好，因此尝试简化。定义
$ Q_i (t_i^prime) = integral_(T_(-i)) x_i (t_i^prime, t_(-i)) f_(-i) (t_(-i)) d t_(-i) $
则$Q_i (t_i^prime)$的含义为，当其他买家诚实报价，买家$i$报价$t_i^prime$时，他获得物品的概率。定义
$ M_i (t_i^prime) = integral_(T_(-i)) p_i (t_i^prime, t_(-i)) f_(-i) (t_(-i)) d t_(-i) $
则$M_i (t_i)$的含义为，当其他买家诚实报价，买家$i$报价$t_i^prime$时，他的期望支付。因此，$U_i (t_i^prime)$可以简化为
$ U_i (t_i^prime) = t_i Q_i (t_i^prime) - M_i (t_i^prime) $
这就与 DSIC 情况下的$u_i (t_i^prime) = t_i dot x_i (t_i^prime) - p_i (t_i^prime)$形式上一致了，只是获得物品的概率和支付都求了期望，并且假定了其他买家如实报价。

因此仿照 DSIC 迈尔森引理可以给出 BIC 版本的迈尔森引理，并且证明过程完全类似，因此不再赘述，除了需要注意积分下界因为显示机制要求报价集合$T_i = [a_i, b_i]$而变为了$a_i$：

BIC 迈尔森引理：一个拍卖机制是 BIC（即贝叶斯激励相容）的，当且仅当其分配规则和支付规则$(x,p)$满足：
- $Q_i (t_i)$是单调不减函数；
- 对任意的$i in N$和$b in [a_i, b_i]$，有 
$ M_i (b) = M_i (a_i) + b Q_i (b) - integral_(a_i)^(b) Q_i (s) d s $

=== 3.合理的机制

由此得到了 BIC 的充要条件。然而现在还不能转入最大化卖家收益的讨论，因为仅满足 BIC 的机制是不够合理（feasible）的。合理的机制除了满足 BIC 外，还应当满足如下两个条件：
- 第一个条件是分配规范性，因为只有一个物品在分配，故对于所有$t in T$，有 $ sum_(i=1)^n x_i (t) <= 1 $  并且$x_i (t) >= 0$对所有$i in N$和$t in T$成立；
- 第二个条件是，对所有$i in N$和$t_i in [a_i, b_i]$，有$U_i (t_i) >= 0$，即需要满足（事中阶段的）个人理性，否则竞拍者在得知自己的类型后会选择退出拍卖。

下面的定理给出了在 BIC 的基础上满足个人理性的充要条件：

定理：一个 BIC 的拍卖机制是 IR（个人理性）的，当且仅当对于每个$i in N$都满足$M_i (a_i) <= 0$

即要求当竞拍者估值为最低值时的期望支付小于等于 0。

证明: 根据 BIC 的条件，不难写出
$ U_i (t_i) = t_i Q_i (t_i) - M_i (t_i) = integral_(a_i)^(t_i) Q_i (s) d s - M_i (a_i) $
个人理性要求对任意的$t_i in [a_i, b_i]$，都有$U_i (t_i) >= 0$，因为等式右侧当$t_i = a_i$时取最小值$- M_i (a_i)$，故个人理性成立当且仅当$M_i (a_i) <= 0$。

总结：给出了合理机制的三个条件，即 BIC、分配规范性和 IR，以及 BIC和 IR 的等价条件。基于上述讨论可以开始考虑如何设计最优机制。

=== 4.转化为虚拟福利最大化问题

首先当所有买家如实报告自己的类型时，投标结果为$t=(t_1,...,t_n)$，卖家期望收入是（注意卖家对物品估值为 0，故只有卖出才能产生收益）
$ U_0 = integral_(T) (sum_(i=1)^n p_i (t)) f(t) d t $
下面这一引理给出了最大化卖家收入$U_0$的合理的最优机制的一个简洁明了的条件：

引理：假设分配规则$x$最大化
$ integral_T (sum_(i=1)^n (t_i - (1 - F_i (t_i))/(f_i (t_i))) x_i (t)) f(t) d t $
支付规则$p$使得$M_i (a_i) = 0$对所有$i in N$成立，且$(x,p)$满足 BIC、分配规范性和 IR，则$(x,p)$是合理的最优机制。

引理的具体证明因为技术性较强不展开描述，下面描述大致步骤：
+ 根据 BIC 迈尔森引理和展开$U_0$的表达式，然后利用积分变换技巧得到  $ U_0 = integral_T (sum_(i=1)^n (t_i - (1 - F_i (t_i))/(f_i (t_i))) x_i (t)) f(t) d t + sum_(i=1)^n M_i (a_i) $
+ 从而目标转化为在满足 BIC、分配规范性和 IR 的情况下最大化上式。其加号前的部分只与分配规则$x$有关，加号后的部分展开后只与支付规则$p$有关，因此可以分别考虑这两个部分：
   - 对于加号前的部分，目标就是找到分配机制$x$使其最大化；
   - 对于加号后的部分，根据个人理性等价条件有$M_i (a_i) <= 0$，因此要最大化$U_0$就要选择支付规则$p$使得$M_i (a_i) = 0$对所有$i in N$成立。

由此，这一引理的结论得证。

有了这一引理，接下来的任务就是找到一个分配机制$x$使得
$ integral_T (sum_(i=1)^n (t_i - (1 - F_i (t_i))/(f_i (t_i))) x_i (t)) f(t) d t $
最大化，而支付规则在$x$确定后直接根据迈尔森引理以及$M_i (a_i) = 0$的条件确定即可。

令
$ c_i (t_i) = t_i - (1 - F_i (t_i))/(f_i (t_i)) $
称其为竞拍者$i$的虚拟估值（virtual valuation），则目标就是找到一个分配机制$x$使得
$ integral_T (sum_(i=1)^n c_i (t_i) x_i (t)) f(t) d t $
最大化。

如果对任意的$t$，都能找到一个$x$使得
$ sum_(i=1)^n c_i (t_i) x_i (t) $
最大化，自然也能满足最大化要求。
- 因此，目标进一步转化为找到一个分配机制$x$使得对任意的$t$，都能找到一个$x$使得$sum_(i=1)^n c_i (t_i) x_i (t)$最大化；
- 如果$c_i (t_i)$是竞拍者$i$的真实估值，那么最大化$sum_(i=1)^n c_i (t_i) x_i (t)$就是最
大化竞拍者福利，然而$c_i (t_i)$并不是真实估值，只是虚拟估值，因此这一问题称为虚拟福利最大化问题。

=== 5.整体研究思路总结

总而言之，经过一系列的积分变换和问题转化，最大化卖家收益的问题被转化为了虚拟福利最大化问题。下面可以总结研究这一问题的完整思路：
  
  (1)利用显示原理将机制设计空间限制在直接显示机制，因此只需要设计竞拍者如实报告估值的机制，因此卖家收益最大化问题可以写为如下数学规划问题：
  #grid(
  columns: (auto, 1fr),
  row-gutter: 0.8em,
  align: (right, left),

  $max_(x,p)$,
  $ U_0 = integral_T lr(sum_(i=1)^n p_i(t)) f(t) d t $,

  [s.t.],
  [
    $ (x,p) $ 满足 BIC, \
    $ (x,p) $ 满足个人理性, \
    $ sum_(i=1)^n x_i(t) <= 1. $
  ],
)

(2)利用 BIC 迈尔森引理将 BIC 转化为两个等价条件，其一是期望分配概率$Q_i$的单调性，其二是期望支付$M_i$可由$Q_i$和$M_i (a_i)$唯一表达；

(3)将个人理性条件转化为等价条件$M_i (a_i) <= 0$；

(4)将目标函数利用积分变换等将目标问题转化为虚拟福利最大化问题。

第 2 - 4 步实际上就是将数学规划的约束和目标函数变得更加清晰，从而可以在下一节中给出显示的最大化解。

== 二、最优机制

=== 1.虚拟福利最大化的解

下面的任务是决定最优的分配机制$x$使得虚拟福利最大化。事实上不难看出如何做到这一点：
- 因为最大化目标函数是$sum_(i=1)^n c_i (t_i) x_i (t)$，且要求$sum_(i=1)^n x_i (t) <= 1$，故而实际上要最大化的就是$c_i (t_i)$的一个加权平均，其中权重和不大于 1；
- 显然只需要给$c_i (t_i)$最大的一项或多项赋予和为 1 的权重即可，并且这一最大值必须要大于等于 0，否则不如全部权重都为 0 的情况。即只允许同时满足
   - 最大化$c_i (t_i) = t_i - (1 - F_i (t_i))/(f_i (t_i))$
   - $c_i (t_i) >= 0$

两个条件的参与人$i$有获得物品的概率，并且如果有这样的参与人，他们获得物品的概率和为 1。换一种说法，即
$ p_i (t) > 0 => c_i (t_i) = max_(j in N) c_j (t_j) >= 0 $

=== 2.正则化条件

然而时刻要记住，我们设计的机制必须是合理的，即满足 BIC、分配规范性和 IR；
- 显然上述解已经满足了分配规范性，IR 与分配机制的选择无关，因此只需要考虑 BIC；
   - 根据 BIC 迈尔森引理，其中第二条与支付机制的选择有关，因此只需要检验第一条$Q_i (t_i)$单调不减是否满足；
   - 这一条件并非一定成立，例如当$c_i$为递减函数时，反而最低的估值会获得物品；
- 因此引入一个充分条件（称为正则化条件）来保证这一要求的成立：称这一问题符合正则化条件，如果对于任意的$i in N$，都有$c_i (t_i)$关于$t_i$是单调递增的；
   - 这显然是$Q_i$关于$t_i$单调递增的充分条件，因为如果$c_i (t_i)$关于$t_i$单调递增，那么根据之前$x_i$的选择，当参与人$i$提高报价时，他得到物品的概率不会降低，从而$Q_i$关于$t_i$单调递增也成立；
   - 因此当满足正则化条件时，上面给出的解的确是合理的最优机制。

=== 3.正则化条件下的解

对于大部分熟知的分布，正则化条件都是满足的；
- 例如 $[0, 1]$ 上的均匀分布，对应的$c_i (t_i) = 2 t_i - 1$是单调递增的；
- 当然从理论层面上讲，仍需考虑正则化条件不满足的情况（例如分布是双峰分布），这一情况的解略为复杂，因此不在此展开（但很经典）。

现在继续考虑正则化条件满足的情况，已有正则化条件下的最优机制的分配规则$x$，接下来需要确定支付规则$p$。不难理解分配规则仍然是一个阶梯函数，令
$ z_i (t_(-i)) = inf {s_i | c_i (s_i) >= 0 "且" c_i (s_i) >= c_j (t_j), forall j != i} $
即$z_i (t_(-i))$是使得参与人$i$刚好能有机会获得物品的最低报价，也就是阶
梯函数的间断点。那么根据支付公式
$ p_i (b, t_(-i)) = b dot x_i (b, t_(-i)) - integral_(a_i)^(b_i) x_i (s, t_(-i)) d s $
可以解出分配规则对应的支付规则$p$为（回忆阶梯函数的直观）
$
p_i (t) = cases(
  z_i (t_(-i)) x_i (t), c_i (z_i (t_(-i))) >= t_0 "且" c_i (z_i (t_(-i))) >= c_j (t_j) forall j != i,
  0 "                     其他情况"
)
$
更简单的，如果只有一个满足$c_i (z_i (t_(-i))) >= t_0$和$c_i (z_i (t_(-i))) >= c_j (t_j), forall j != i$的$i$，则$x_i (t) = 1$且
$
p_i (t) = cases(
  z_i (t_(-i))"," x_i (t) = 1,
  0",      " x_i (t) = 0
)
$
=== 4.买家估值独立同分布情形

考虑一种最简单的情况来具象化前面给出的结论。考虑一个所有买家估值独立同分布的情形（即对称模型），并且符合正则化条件，不难得到
$ z_(-i) = max {c^(-1) (t_0), max_(j != i) t_j} $
- 结合前面得到的$(x,p)$，此时的最优机制其实就是一个含保留价格的二价拍卖机制，其中保留价格为$c^(-1) (t_0)$
- 因为此时所有买家估值同分布，因此虚拟估值函数也相同，故具有最高估值（最高报价）的赢得物品，并且支付第二高报价和保留价格之间的较高者，并且如果最高报价低于保留价格，则不分配物品。

更具体而言，当所有买家估值独立且服从$[0, 1]$上的均匀分布时，虚拟估值函数为$c_i (t_i) = 2 t_i -1$，因此保留价格为$1/2$，此时的最优机制就是保留价格为 $1/2$ 的第二价格拍卖。

=== 5.最大的利润

当所有买家估值独立且服从$[0, 1]$上的均匀分布时，求最优机制下卖家的收益。

#figure(
  image("/images/image24.png", width: 80%),
) <fig:fig24>

问题：为什么最优机制能打破收入等价原理的限制，获得更高的收益？

尽管最优机制可以使得买家获得最大的期望效用，但是这一机制存在一些天然的缺陷：
+ 卖家很难准确估计每一个买家的估值分布，因此这一机制很难完美实现，特别是应用于数据拍卖场景时，数据买家的估值不确定性更大，因此之后会讨论在无先验分布下的机制设计；
+ 非对称模型（即买家的估值不同分布）下，报价最高的买家可能并不是最有可能获得物品的买家。这一点非常显然，因为不同的分布下$c$的形态会有所不同；
   - 若$f_i (t_i) = 1/(b_i - a_i)$，即买家的估值均匀分布，不难计算得到$c_i (t_i) = 2 t_i - b_i$，这关于$t_i$是单调递增的，因此符合正则化条件；
   - 但是此时的最优机制是选出$2 t_i - b_i$最大的$i$，如果$b_i < b_j$，那么可能存在$t_i < t_j$但是$2 t_i - b_i > 2 t_j - b_j$的情况，即报价更低的买家可能获得物品；
+ 最优机制不是事后有效率的，例如我们考虑对称模型下，卖家估值等于0且买家估值都大 0的情况，此时显然物品要售出才是福利最大化（也是帕累托最优或事后有效率）的，但是如果所有买家的报价都
低于$c_i^(-1) (0)$，那么物品就不会被售出，这显然不是事后有效率的。

== 三、拍卖与数据定价