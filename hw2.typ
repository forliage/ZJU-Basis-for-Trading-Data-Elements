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

= HW2:机制设计与信息设计基础

姓名：  学号：  日期：

== 2.1.$N$人一价拍卖均衡

假设有$N$个竞拍者，并且$N$个竞拍者的估计是独立的，且都服从$[0,1]$上的均匀分布。$N$个竞拍者的真实估值记为$t_1,...,t_n$。
+ 求解博弈的递增对称纯策略贝叶斯纳什均衡$beta$(注意$beta(0)=0$)；
+ 从上述结果中你能获得什么启示？

*Solution*:

*1.*在一个对称的均衡中，所有竞拍者都使用相同的竞价函数$beta(t)$。我们假设这个函数是严格递增的。考虑竞拍者$i$，其真实估值为$t_i$。他的目标是选择一个出价$b_i$来最大化自己的期望效用。
- 如果他赢了（即$b_i$是最高出价），效用为$t_i - b_i$。 
- 如果他输了，效用为 0。

因此，竞拍者$i$的期望效用$bb(E)[U_i]$是：
$ bb(E)[U_i (b_i | t_i)] = (t_i - b_i) times P("用"b_i"获胜") $
由于所有其他竞拍者$j(j != i)$都使用策略$beta(t_j)$，竞拍者$i$以出价$b_i$获胜的条件是他的出价高于所有其他人的出价：$b_i > beta(t_j)$对所有$j != i$成立。

因为我们假设$beta(dot)$是严格递增的，所以它存在一个反函数$beta^(-1) (dot)$。条件$b_i > beta(t_j)$等价于$beta^(-1) (b_i)>t_j$。 

竞拍者$i$获胜的概率就是其他所有$N-1$个竞拍者的估值都小于$beta^(-1) (b_i)$的概率。
$ P("获胜") = P(t_j < beta^(-1) (b_i) " for all " j != i) $
由于所有$t_j$都是独立的，并且服从$[0,1]$上的均匀分布（即$P (t_j < x) = x$），这个概率为：
$ P("获胜") = [P(t_j < beta^(-1) (b_i))]^(N-1) = [beta^(-1) (b_i)]^(N-1) $
将获胜概率代入期望效用函数，竞拍者$i$的目标是选择$b_i$来最大化：
$ bb(E)[U_i (b_i | t_i)] = (t_i - b_i) [beta^(-1) (b_i)]^(N-1) $
在均衡状态下，竞拍者$i$的最优选择必须是遵循策略，即出价$b_i = beta (t_i)$。这意味着，如果一个估值为$t_i$的人假装自己的估值是$hat(t)$并出价$beta( hat(t))$，他的效用在$hat(t) = t_i$时达到最大。

我们令一个估值为$t_i$的竞拍者选择一个“声明的估值”$hat(t)$，从而其出价为$b = beta( hat(t))$。他的期望效用为：
$ U (hat(t), t_i) = (t_i - beta( hat(t))) dot P( beta(hat(t))"获胜") $
获胜的概率是其他所有人的真实估值都小于$hat(t)$的概率，即$(hat(t))^(N-1)$。 
$ U (hat(t), t_i) = (t_i - beta( hat(t))) (hat(t))^(N-1) $
为了让$beta(dot)$成为一个均衡策略，对于任何$t_i, hat(t)=t_i$都必须是最大化上述效用函数的选择。我们使用一阶条件（FOC），对$hat(t)$求导并令其为 0：
$ (partial U)/(partial hat(t)) = - beta^prime (hat(t)) (hat(t))^(N-1) + (t_i - beta(hat(t))) (N - 1) (hat(t))^(N-2) = 0 $
在均衡时，我们必须有$hat(t) = t_i$。将此条件代入一阶条件中：
$ - beta^prime (t_i) (t_i)^(N-1) + (t_i - beta (t_i)) (N - 1) (t_i)^(N-2) = 0 $
这是一个一阶常微分方程。为了求解$beta(t_i)$，我们整理方程（假设$t_i > 0$）： 
$ beta^prime (t_i) t_i - (N - 1) (t_i - beta(t_i)) = 0 $
$ t_i beta^prime (t_i) + (N - 1) beta (t_i) = (N - 1) t_i $
积分因子$I(t_i)$为：
$ I(t_i) = e^(integral (N-1)/(t_i) d t_i) = e^((N - 1) ln (t_i)) = t_i^(N-1) $
将方程两边乘以积分因子$t_i^(N-1)$：
$ t_i^(N-1) beta^prime (t_i) + (N - 1) t_i^(N-2) beta (t_i) = (N - 1) t_i^(N-1) $
$ ==> (d)/(d t_i) [t_i^(N-1) beta (t_i)] = (N-1) t_i^(N-1) $
积分得到：
$ t_i^(N-1) beta (t_i) = integral (N-1) t_i^(N-1) d t_i = (N - 1) (t_i^N)/N + C $
解得：
$ beta (t_i) = (N-1)/N t_i + (C)/(t_i^(N-1)) $
由$beta(0)=0$得到$C=0$，否则$t_i ->0$时，该项会趋近于无穷。
即，唯一解是：
$ beta (t_i) = (N-1)/N t_i $

*2.*从均衡竞价策略$beta (t_i) = (N-1)/N t_i$中，我们可以得到以下几个重要的经济学启示：
+ 出价折让 (Bid Shading)：均衡策略表明，理性的竞拍者不会出价其真实估值$t_i$，而是会出一个打了折扣的价格。折扣因子是$(N-1)/N$。这种行为被称为“出价折让”。其根本原因在于第一价格拍卖的支付规则：如果你赢了，你支付的是你自己的出价。为了在获胜时能获得正的收益（即$t_i - b_i > 0$），你的出价$b_i$必须严格小于你的真实估值$t_i$。出价太高会减少你的潜在利润，而出价太低会降低你的获胜概率。这个公式给出了在这两者之间权衡的最优解。
+ 竞争的影响：竞价函数明确地依赖于竞拍者的总数$N$
   - 当竞拍者数量$N$增加时，比率$(N-1)/N = 1 - 1/N$会趋近于1。
   - 这意味着，随着竞争变得越来越激烈，每个竞拍者的出价会越来越接近其真实估值。例如，在只有两个竞拍者$(N=2)$的情况下，出价是$beta (t_i) = 1/2 t_i$，折让幅度很大。但当有 10 个竞拍者 ($N=10$)，出价是$beta (t_i) = 9/(10) t_i$，已经相当接近真实估值了。
   - 直觉解释：当有更多竞争对手时，你为了获胜所需要击败的对手就越多。为了不被别人轻易超越，你必须更积极地出价。对失去拍卖的恐惧超过了对赢得拍卖时支付过多的担忧，从而推高了整体的出价水平。
+ 收益等价性原理的体现 (Revenue Equivalence Theorem)：我们可以计算一下在此拍卖中卖家的期望收益。卖家的收益是最高出价$max (b_1,...,b_N)$。因为出价函数是递增的，拥有最高估值$t_((N))$的人会给出最高出价$beta (t_((N))) = (N-1)/N t_((N))$。卖家的期望收益为$bb(E) ["Revenue"]=bb(E)[ (N-1)/(N) t_(N)] = (N-1)/N bb(E) [t_((N))]$。 对于$N$个从$[0,1]$均匀分布中抽取的独立样本，最大值统计量$t_((N))$的期望值为$bb(E) [t_((N))]= N/(N+1)$。因此，卖家的期望收益为：$ bb(E) ["Revenue"] = (N-1)/N dot N/(N+1) = (N-1)/(N+1) $

== 2.2.收入等价原理

有$N$个竞拍者，并且$N$个竞拍者的估值是独立的，且都服从$[0,1]$上的均匀分布。考虑如下规则的全
支付拍卖：每个竞拍者提交一个报价，报价最高的竞拍者赢得物品，但所有竞拍者无论是否获得物品都
要支付自己的报价。注意，以下讨论只考虑考虑估价为 0 的竞拍者的期望支付为 0 的递增对称均衡。
+ 求 2.1 题的均衡下一个估值为$x$的竞拍者的均衡期望支付$m(x)$；
+ 求 2.1 题的均衡下卖家的期望收入；
+ 根据收入等价原理证明：全支付拍卖的递增对称均衡就是$beta(x) = m(x)$。

*Solution*:

*1.* 在问题 2.1 中，我们已经求出第一价格拍卖（First-Price Auction）的均衡竞价策略为$beta_(F P) (t) = (N-1)/N t$。一个估值为$x$的竞拍者的期望支付（Expected Payment）是指他每次参与拍卖平均需要支付的金额。在第一价格拍卖中，只有获胜时才需要支付，所以期望支付等于其出价乘以获胜的概率。

出价: 对于估值为$x$的竞拍者，他的出价是$b = beta_(F P) (x) = (N-1)/N x$。 

获胜的概率: 该竞拍者获胜，当且仅当他的估值$x$高于其他所有$N-1$个竞拍者的估值。
$ P("获胜") = P(t_j < x " for all " j != i) $
由于所有估值$t_j$独立服从$[0,1]$均匀分布，因此$P(t_j <x)=x$。 
$ P("获胜") = x^(N-1) $
$ m(x) = ((N-1)/N x) dot (x^(N-1)) = (N-1)/N x^N $

*2.*在第一价格拍卖中，卖家的收入等于获胜者的出价，也就是所有出价中的最高价。由于竞价函数$beta_(F P) (t) = (N-1)/N t$是严格递增的，拥有最高估值的竞拍者将会提交最高的出价。设所有$N$个竞拍者中的最高估值为$t_((N))$。 

最高出价: 获胜者的出价为$beta_(F P) (t_((N))) = (N-1)/N t_((N))$

卖家的期望收入: 卖家的期望收入就是对这个最高出价求期望值。
$ bb(E) ["收入"] = bb(E) [beta_(F P) (t_((N)))] = bb(E) [ (N-1)/N t_((N))] = (N-1)/N bb(E) [t_((N))] $

最高估值的期望: 对于$N$个从$[0,1]$均匀分布中独立抽取的样本，其最大值的期望值$bb(E) [t_((N))]$一个标准统计学结论：
$ bb(E) [t_((N))] = N/(N+1) $
计算结果：
$ bb(E)["收入"] = (N-1)/N dot N/(N+1) = (N-1)/(N+1) $

*3.* 我们可以应用收入等价原理。该原理指出，对于任何给定的估值$x$，竞拍者在两种拍卖机制下的期望支付必须是相等的。

- 第一价格拍卖的期望支付: 我们在第 1 问中已经求出，对于估值为$x$的竞拍者，其期望支付为$m(x)= (N-1)/N x^N$
- 全支付拍卖的期望支付: 在全支付拍卖中，根据规则，竞拍者无论输赢都必须支付其出价。因此，如果一个竞拍者遵循某个竞价策略$beta_(A P) (x)$，那么他的支付额是确定的，就是他出的价钱$beta_(A P) (x)$。他的期望支付就等于他的出价本身。$ bb(E) ["支付"_(A P)] = beta_(A P) (x) $
- 根据收入等价原理，两种机制下的期望支付必须相等：$ bb(E) ["支付"_(A P)] = m(x) $  $ beta_(A P) = (N-1)/N x^N $

根据收入等价原理，我们证明了在满足所述条件的设定下，全支付拍卖的递增对称均衡竞价函数就是 $beta (x) = m(x) = (N-1)/N x^N$。 

这揭示了一个深刻的联系：一种拍卖机制下的均衡竞价函数（全支付拍卖），可能等于另一种拍卖机制下的均衡期望支付函数（第一价格拍卖）。


== 2.3.反向拍卖的迈尔森引理

在反向拍卖中，买家作为拍卖师通常具有一些采购需求，竞拍者是待采购产品的卖家。每位竞拍者$i$报出自己产品的成本$c_i$，买家收到所有竞拍者报告的成本向量后决定分配规则$x$和支付规则$p$，其中$x_i (c_i)$表示竞拍者$i$报告成本$c_i$时购买竞拍者$i$产品的概率，$p_i (c_i)$表示竞拍者$i$报告成本$c_i$且竞拍者$i$的产品被购买时给竞拍者$i$的支付。

假设竞拍者的产品没有被卖出时的效用为 0，因此竞拍者$i$报出任意的$c_i^prime$时的期望效用可以表达为
$ u_i (c_i^prime) = x_i (c_i^prime) dot (p_i (c_i^prime) - c_i) $
+ 根据 DSIC 的定义写出反向拍卖机制$(x,p)$满足 DSIC 时竞拍者效用应当满足的条件；
+ 根据课上给出的迈尔森引理，给出并证明反向拍卖机制是 DSIC 的充要条件（假设$c -> infinity$时，$c dot x_i (c) -> 0$且$p_i (c) dot x_i (c) -> 0$）。

== 2.4.虚拟估值和正则性条件

本题将推导出对于虚拟估值$c(v) = v - (1 - F(v))/(f(v))$和正则化条件的有趣描述。考虑$[0, v_("max")]$上严格单调递增的分布函数$F$，其概率密度函数$f$为正，其中$v_("max") < + infinity$。对于估值服从分布$F$的竞拍者，当交易成功概率为$q in [0,1]$时，定义$V(q) = F^(-1) (1 - q)$为物品的 “价格”，进而可以定义$R(q) = q dot V(q)$为从竞拍者处获得的期望收益。称$R(q)$为$F$的收益曲线函数，注意$R(0)=R(1)=0$。 
+ 请解释为什么$V(q)$可以被视为物品的价格；
+ $[0,1]$上的均匀分布的收益曲线函数是什么？
+ 证明收益曲线在$q$点的斜率（即$R^prime (q)$）是$c(V(q))$，其中$c$是虚拟估值函数；
+ 证明当且仅当收益曲线是凹的时候，概率分布是正则的。

== 2.5.贝叶斯劝说：检察官与法官

考虑检察官劝说法官判决的例子：假设法官（信号接收者）对于一个被告人，必须做出以下两种决策之一：判决有罪（convict）或无罪释放（acquit）。
- 被告人有两种类型：有罪（guilty）或无罪（innocent）；
- 法官在公正判决下获得的效用为 1：如果有罪被判有罪，无罪被判无罪，否则效用为 0；
- 检察官（信号发送者）为法官提供有关被告的证据（发送信号），如果被告人判有罪，检察官获得效用 1，否则效用为 0；
- 法官和检察官对被告人的类型有相同的先验概率分布：$mu_0 ("guilty")=0.3,mu_0 ("innocent") = 0.7$。

检察官进行调查收集有关被告人的证据，因此检察官的策略是选择一个提供证据的策略，希望改变法官
的判决，使得被判有罪的越多越好（检查官效用最大化）。形式化地说，提供证据就是一个$pi (dot |"guilty")$和$pi(dot | "innocent")$的信号机制，并且这一信号机制在博弈前是公开给法官的（或者说可验证的）。
+ 根据信息设计的显示原理，给出下面需要考虑的信号机制的形式；
+ 求检察官使用完全诚实的信号机制的情况下，检察官和法官的效用；
+ 求检察官最优信号机制下检察官的效用，以及最优信号机制下法官后验概率分布的分布；
+ 求检察官的最优信号机制。

== 2.6.信息的价值

设自然的状态集合为$Omega={omega_1, omega_2}$，买家的先验分布为$mu_0 (omega_1) = 0.7, mu_0 (omega_2) = 0.3$。设买家的行动集合为$A={a_1, a_2}$，效用函数为
$ u(a_1, omega_1) = 2, u(a_1, omega_2) = 0 $
$ u(a_2, omega_1) = 0, u(a_2, omega_2) = 3 $
记$mu_0 (omega_1) = theta$，则$mu_0 (omega_2) = 1 - theta$。假设有一个数据卖家提供如下信号机制：$S={s_1, s_2}$，且
$ pi(s_1 | omega_1) = 0.9, pi(s_2 | omega_1) = 0.1 $
$ pi(s_1 | omega_2) = 0.7, pi(s_2 | omega_2) = 0.3 $
求卖家信号机制对买家的价值。