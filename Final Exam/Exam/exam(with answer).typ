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

= 期末测试（解答版）

== 一、名词解释（每题2分，共10分）

1.柠檬市场  

2.子博弈完美均衡 

3.组合无套利 
 
4.DSIC 
 
5.比较优势

*Solution:*

1.柠檬市场：柠檬市场是指在信息不对称的情况下，卖方比买方拥有更多关于产品质量的信息，导致买方因无法分辨好坏而只愿意支付基于平均质量的价格。这使得高质量产品的卖方无利可图而退出市场，最终市场上只剩下低质量的“次品”（即柠檬），出现“劣币驱逐良币”的市场失灵现象。（来源：Lecture 3, page 4, 第8节“市场失灵”的最后一个段落及 page 5 的二手车市场例子）

2.子博弈完美均衡:在扩展式博弈中，一个策略向量是子博弈完美均衡，指的是该策略向量在整个博弈的每一个子博弈上都构成一个纳什均衡。这一概念通过要求策略在博弈的每个阶段都必须是最优的，从而排除了那些包含不可置信威胁的纳什均衡。
(来源：Lecture 4, page 4, 第3节“子博弈完美均衡”的定义部分)

3.组合无套利:组合无套利是指在数据定价中，一个查询如果可以被拆分为多个子查询来完成，那么这一个整体查询的价格不应高于所有子查询价格的总和。这个原则旨在防止买家通过组合多个低价查询来绕开一个高价的等效查询，从而实现套利。
(来源：Lecture 9, page 4, 标题为“组合无套利研究...”下的定义部分)
 
4.DSIC:DSIC是“占优策略激励相容”（Dominant-Strategy Incentive Compatible）的缩写。在机制设计中，如果一个机制使得每个参与者无论其他人的策略如何，其自身的占优策略都是诚实地报告自己的类型（如真实估值），那么这个机制就是DSIC的。
(来源：Lecture 7, page 7, 第3节“直接显示机制”的定义2)
 
5.比较优势:如果一个生产者在生产某种物品时，其机会成本（即为生产该物品而必须放弃的其他物品的数量）低于另一个生产者，那么我们就说这个生产者在生产该物品上具有比较优势。贸易的基础是比较优势，而非绝对优势。
(来源：Lecture 1, page 4, 第4节“比较优势”的定义部分)

