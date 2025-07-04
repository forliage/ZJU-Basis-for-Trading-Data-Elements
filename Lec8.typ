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



== 二、最优机制

== 三、拍卖与数据定价