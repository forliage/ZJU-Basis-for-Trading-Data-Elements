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

= Lecture 5：合作博弈与数据估值

== 一、从非合作博弈到合作博弈

=== 1.合作博弈

定义：一个具有可转移效用（transferable utility）的合作博弈（或称为 TU 博弈）是一个满足如
下条件的二元组$(N;v)$:
+ $N={1,2,...,n}$是一个有限的参与者集合；一个$N$的子集被称为一个联盟（coalition），全体联盟构成的集合记为$2^N$；
+ $v:2^N -> bb(R)$称为该博弈的特征函数（characteristic function），对于任意的$S subset N$，$v(S)$表示联盟$S$的价值（worth），且满足$V(Phi) = 0$

定义：一个合作博弈$(N;v)$（其中$N={1,2,...,n}$）的解概念是一个函数$phi$，它将每个博弈$(N;v)$与一个$bb(R)^n$的子集$phi (N;v)$联系起来．如果对于任意的博弈$phi (N;v)$都是一个单点集，则称这一解概念为单点解（point solution）．

更通俗地说，合作博弈的解概念就是一个将每个博弈都映射到一个可行的收入分配集合的函数，这个集合中的每个元素是一个分配向量$(x_1,x_2,...,x_n)$，其中$x_i$表示参与者$i$在当前分配下可以获得的收入。

=== 2.分摊美元博弈

考虑一个场景，假设有三个人 A，B，C，他们的特点分别如下：
+ A 擅长于发明专利，依靠这一才能年收入达 17 万美元；
+ B 有机敏的商业嗅觉，能准确发掘潜在市场，创建商业咨询公司年收入可达 15 万美元；
+ C 擅长市场营销，开办专门的销售公司年收入可达 18 万美元

显然，三个人的才能互补，于是他们考虑合作：B 可以为 A 提供市场资讯，将 A 的发明专
利卖给市场上最有需求的人，这样他们合作每年收入可达 35 万美元；C 利用他的才能销售
A 的发明专利，合作年收入可达 38 万美元；当然 B 和 C 也可以合作组建一个提供市场咨
询和销售一体化的公司，这样每年合作收入可达 36 万美元；最后 A，B，C 如果共同合作，
A 在 B 的建议下发明最符合市场需求的专利，然后由 C 进行销售，这样他们合作每年收入
可达 56 万美元．

现在可以用定义形式化这一博弈．不难得到$N={A,B,C}$，全体联盟构成的集合
$ 2^N = {Phi, {A}, {B}, {C}, {A,B}, {B,C}, {A,C}, {A,B,C}}, $
则该场景可以表示为一个合作博弈$(N;v)$，其中特征函数$v$定义如下：
$
 v(S) = cases(
  0 quad S=Phi,
  17 quad S={A},
  15 quad S={B},
  18 quad S={C},
  35 quad S={A,B},
  36 quad S={B,C},
  38 quad S={A,C},
  56 quad S={A,B,C},
 )
$

设$(N;v)$是一个三人参与的合作博弈，其中$N={1,2,3}$，特征函数$v$定义如下：
$ v(Phi) = v({1}) = v({2}) = v({3}) = 0, $
$ v({1,2}) = v({1,3}) = v({2,3}) = v({1,2,3}) = 1 $

这是三人分 300 元的最后一个例子的形式化版本．现在讨论这一博弈的可行解概念，可以从两个不同的角度来考虑这一问题：
+ 如果你是参与者，你会认为两两组成联盟是最好的，结合对称性，你会认为这一博弈的解概念是$phi (N; v) = {(1/2, 1/2, 0),(1/2, 0, 1/2),(0, 1/2, 1/2)}$，即你心中的解概念是一个三
个元素的集合；
+ 如果你是局外人，你认为三个参与人是 “对称的”，因此这一博弈的解概念应当是$phi (N;v) = {(1/3, 1/3, 1/3)}$，只有一个向量组成．

== 二、核

== 三、数据估值

== 四、Shapley值计算