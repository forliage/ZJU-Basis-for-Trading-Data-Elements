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

== 2.2.收入等价原理

有$N$个竞拍者，并且$N$个竞拍者的估值是独立的，且都服从$[0,1]$上的均匀分布。考虑如下规则的全
支付拍卖：每个竞拍者提交一个报价，报价最高的竞拍者赢得物品，但所有竞拍者无论是否获得物品都
要支付自己的报价。注意，以下讨论只考虑考虑估价为 0 的竞拍者的期望支付为 0 的递增对称均衡。
+ 求 2.1 题的均衡下一个估值为$x$的竞拍者的均衡期望支付$m(x)$；
+ 求 2.1 题的均衡下卖家的期望收入；
+ 根据收入等价原理证明：全支付拍卖的递增对称均衡就是$beta(x) = m(x)$。

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