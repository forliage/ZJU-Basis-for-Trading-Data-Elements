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

= Lecture 7 :拍卖与机制设计基础

== 一、拍卖理论基础

=== 1.出售物品的方式

如何出售一个物品？除了最常见的摆在超市货架上以固定价格出售的方式，我们的脑海中不难浮现出菜市场中买卖双方讨价还价的场景，也隐约能想起与日常生活有些遥远的“100 万第三次，成交”的拍卖形式。通常而言，出售物品的方式可以分为以下两种方式：
- 公布价格（posted pricing）：指以在菜单/货架等上标明的固定价格出售物品的方式，餐厅吃饭、超市和互联网购物等都是这种方式的例子。
- 拍卖（auction）：指以买方出价、卖方出价或买卖双方互相出价决定最终物品的出售对象以及出售价格的方式，其中的出价称为投标（bid），通俗而言也可称报价；讨价还价可以建模为买卖双方互相投标的过程，因此也可以视为一类特殊的拍卖。

=== 2.常见的拍卖形式

- 英式拍卖（English auction）或公开升价拍卖（open ascending price auction）：最广为人知的拍卖形式。拍卖师（auctioneer）（不一定是卖家本人，可能只是一个中介）从一个比较低的价格开始，只要还有至少两个感兴趣的竞拍者，就以一个较小的增量逐渐提高价格，直到只剩下唯一一个竞拍者为止。此时唯一的竞拍者赢得拍卖品并向拍卖师支付倒数第二个竞拍者退出时竞拍的价格；
- 荷式拍卖（Dutch auction）或公开降价拍卖（open descending price auction）与英式拍卖相反，拍卖师从一个足够高的价格开始（保证没有竞拍者感兴趣），然后逐渐降低价格，直到有竞拍者愿意接受价格为止。此时该竞拍者赢得拍卖品并向拍卖师支付这个价格。

英式拍卖最熟悉的场景或许就是古董拍卖，当然例如政府土地等的拍卖也是英式拍卖的典型应用。荷式拍卖则在一些特殊场景中有所应用，这一应用与“荷式”这一名字的由来有关：荷兰盛产郁金香，而花卉保质期短，因此拍卖需要尽快完成，显然降价拍卖比升价拍卖更具有时间效率。

英式和荷式拍卖都属于公开拍卖，即所有竞拍者都能看到其他竞拍者的出价。相对的一类场景拍卖称为密封拍卖（sealed-bid auction），即所有竞拍者以密封形式提交竞价，传统的以寄信封形式提交竞价的拍卖即属于这一类，更现代的例子则是在网页上直接提交报价（如 eBay）。

密封价格拍卖中最常见的两种为第一价格拍卖（first-price auction）和第二价格拍卖（second-price auction），简称一价拍卖和二价拍卖。

- 前者指报价最高的竞拍者赢得物品，并支付自己的报价（也就是所有报价中最高的报价）；
- 后者也是报价最高的竞拍者赢得物品，但只需要支付所有报价中第二高的报价。

有的拍卖中会设置保留价格（reserve price），指卖家在拍卖开始前设定的最低出售价格。如果所有报价都低于保留价格，卖家选择不卖出物品。当然有的拍卖也会设置入场费（entry fee），即所有参与者在拍卖开始前需要支付的费用，无论是否赢得拍卖。

在有的拍卖中，不一定只有单个物品待出售，这类拍卖称为多物品拍卖（multi-item auction），只出售一个物品的拍卖称为单物品拍卖（single-item auction）；
- 多物品拍卖中有的是拍卖多个相同物品，例如数据产品拍卖，因为可以数据零成本复制，因此可以在一场拍卖中出售完全一致的多份数据；
- 另一类是可以同时拍卖多个不同物品，例如著名的频谱拍卖，政府可以同时拍卖多个不同频段的无线电频谱。

有的拍卖只需买方一轮投标即可决定拍卖结果，如密封第一、第二价格拍卖，有的拍卖可能需要多轮逐次决定。还有一些拍卖场景需要卖家也提供投标，例如讨价还价（bargaining），或双向拍卖（double auction），一种基本的双向拍卖方式是取买卖双方报价均值为最后的售价。

还有一类拍卖称为反向拍卖（reverse auction）是卖家报价的，在反向拍卖中，买家作为拍卖师通常具有一些采购需求，竞拍者是待采购商品的卖家，买家通过卖家的投标，结合其提供的商品质量决定选择哪些卖家的商品。不难发现，常见的招标就可以使用反向拍卖的方式进行。

总结而言，上面提到的拍卖都可以从三个角度进行分类：
+ 投标规则：只有买家投标，只有卖家投标，还是买卖双方投标？投标是针对单个物品，还是可以同时投标多个物品？是否投标低于某个价格无效？
+ 交易规则：拍卖结果是哪些竞拍者可以获得物品？获得物品的竞拍者需要支付多少？没有获得物品的竞拍者是否需要支付？
+ 信息规则：投标时是否公开其他投标者的报价？

=== 3.单物品密封拍卖的一般框架

== 二、机制设计基础

== 三、福利最大化机制设计