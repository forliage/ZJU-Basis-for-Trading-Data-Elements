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
  footer: align(right)[#counter(page)]
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

= HW1:博弈论与多臂老虎机算法基础

姓名：  学号：  日期：

== 1.1.占优策略均衡与纳什均衡的关系

证明如下关于占优策略均衡与纳什均衡的关系的结论：

1.如果每个参与人$i$都有一个占优于其它所有策略的策略$s_i^*$，那么$s^*=(s_1^*,...,s_n^*)$是纳什均衡；

2.如果每个参与人$i$都有一个严格占优于其它所有策略的策略$s_i^*$，那么$s^*=(s_1^*,...,s_n^*)$是博弈的唯一纳什均衡。

== 1.2.$N$人古诺竞争

假设在古诺竞争中，一共有$J$家企业。当市场中所有企业总产量为$q$时，市场价格为$p(q)=a - b q$。且每个企业生产单位产品的成本都是同一个常数$c$，即企业$i$的产量为$q_i$时该企业的成本为$c_i (q_i) = c dot q_i$。假设$a > c >= 0, b>0$。

1.求纳什均衡下所有企业的总产量以及市场价格；

2.讨论均衡价格随着$J$变化的情况，你有什么启示？

3.讨论$J -> infinity$的均衡结果，你有什么启示？

== 1.3.公地悲剧

假设有$I$个农场主，每个农场主均有权利在公共草地上放牧奶牛。一头奶牛产奶的数量取决于在草地上放牧的奶牛总量$N$：当$N< overline(N)$时，$n_i$头奶牛产生的收入为$n_i dot v(N)$；而当$N >= overline(N)$时，$v(N) equiv 0$。假设每头奶牛的成本为$c$，且$v(0)>c,v'<0,v''<0$，所有农场主同时决定购买多少奶牛，所有奶牛均会在公共草地上放牧(注：假设奶牛的数量可以是小数，也就是无需考虑取整的问题)。

1.将上述情形表达为策略式博弈；

2.求博弈的纳什均衡下所有农场主购买的总奶牛数(可以保留表达式的形式，不用求出具体解)；

3.求所有农场主效用之和最大(社会最优)情况下的总奶牛数(可以保留表达式的形式，不用求出具体解)，与上一问的结果比较，你能从中得到什么启示？

== 1.4.教育作为一种信号

== 1.5.混合策略的不完全信息解释

== 1.6.飞机跑道成本分配的沙普利置计算

== 1.7.$epsilon$-贪心算法的遗憾分析
