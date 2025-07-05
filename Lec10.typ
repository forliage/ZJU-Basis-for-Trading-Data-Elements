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

= Lecture10：贝叶斯劝说

== 一、贝叶斯劝说：背景与例子

考虑导师写推荐信将学生推荐至企业的例子：
- 两个参与人：导师（信号发送者）和企业（信号接收者）
   - 导师的任务是向企业为每位学生写推荐信，通过推荐信的好坏向企业发送信号；
   - 企业的任务是对一个学生，在接收到导师的推荐信（信号）后必须做出以下两种决策之一：雇用（hiring）和不雇用（not hiring）；
   - 学生不是博弈参与方，因为学生只被动接受结果，没有自己的策略。
- 学生有两种类型：优秀（excellent）或一般（average）
   - 学生的类型对导师而言是已知的。对企业则是不完全信息；
   - 与不完全信息博弈中的假设一致，可以认为学生的类型是自然按一定的先验概率随机抽取的；
   - 企业对学生类型有先验分布$mu_0 ("average") = 0.75, mu_0 ("excellent") = 0.25$，这一先验概率分布也符合导师已知的实际学生类型分布，因此如果随机抽取一个学生，则企业和导师对学生类型有共同的先验分布。

还需要定义参与人的效用函数：
- 假设导师希望推荐出去的学生越多越好，因此企业只要雇用一个学生，则导师获得效用 1，否则效用为 0；
- 企业则希望招收到优秀的学生，因此在招收到优秀的学生时获得效用为1，招收普通学生时获得效用为-0.5。

因此接下来需要形式化定义导师的策略，即形式化“发信号”这一策略。

形象地说，发信号就是通过好或坏的推荐信来向企业表明学生是优秀的或一般的。形式化地说，导师写推荐信的策略就是如下两个条件概率分布$pi (dot | "excellent")$和 $pi (dot | "average")$（又称信号机制（signaling scheme））：
$ pi (e | "excellent"), pi(a | "excellent") $
$ pi (e | "average") | pi (a|"average") $
- 其中$e$和$a$分别表示描述学生为优秀类型和一般类型的推荐信；
- $pi (A|B)$表示当学生属于$B$类型时，导师在推荐信中给学生描述的类型为$A$的概率；

一个值得注意的点是，导师和企业之间存在长期关系，因此导师的策略是企业在看到推荐信之前就已知的，因为企业在与导师的长期关系中可以验证导师的策略。

=== 1.诚实推荐

第一个信号的例子是，导师完全诚实地推荐学生，即为优秀的学生写好的推荐信，为一般的学生写一般的推荐信，故此时信号机制为
$ pi (e | "excellent") = 1, pi(a | "excellent") = 0 $
$ pi (e | "average") = 0, pi (a | "average") = 1 $
企业知道导师的推荐信是诚实的，因此将接收所有推荐信中写优秀的学生，拒绝所有推荐信中写一般的学生；
- 此时导师把优秀的同学推出，故在每个学生上的期望效用为 0.25；
- 企业接收所有优秀同学，故在每个学生上的期望效用也为 0.25。

=== 2.完全不诚实推荐

自然地，导师会认为提供诚实的推荐信能推荐出的学生太少，因此极端的导师可能会选择为每个学生都写好的推荐信，这就构成了第二个信号的例子：
$  $
$  $
因此此时企业看到的全是好的推荐信，因此只能保持先验概率去判断学生的好坏：
- 由于每个学生是优秀类型的概率只有 0.25，因此如果企业雇用任意一
个学生，其期望效用为 0.25 × 1 − 0.75 × 0.5 = −0.125，因此企业不
会雇用任何一个学生；
- 此时导师和企业的期望效用均为 0。

=== 3.部分诚实推荐

从之前的例子可以看出，完全诚实和完全不诚实的策略都不是最优的，因此需要更精妙的设计。

之后会证明如下信号最优（即导师效用最大化）：
$ pi (e | "excellent") = 1, pi(a | "excellent") = 0 $
$ pi (e | "average") = 2/3, pi (a | "average") = 1/3 $
即导师会给所有优秀的学生写好的推荐信，对一般的学生则以 2/3 的概率写好的推荐信。

- 当企业看到好的推荐信时，应当有$1/3$的概率认为学生是真的优秀，有$2/3$的概率认为学生一般；
- 企业看到一般的推荐信时则一定认为学生一般。

即企业看到推荐信后对学生类型的后验概率为（记$mu_A (B)$是看到$A$类型推荐信后认为学生属于类型 $B$的概率，其实就是$mu (B | A)$）：
$ mu_e ("excellent") = 1/3, mu_e ("average") = 2/3 $
$ mu_a ("excellent") = 0, mu_a ("average") = 1 $

根据后验概率，看到一般的推荐信代表学生一般，故企业不会雇用；

当看到好的推荐信时，有 $1/3$ 的概率认为是优秀学生，$2/3$ 的概率认为是一般学生，故对于一个好推荐信对应的学生;
- 企业雇用带来的效用为 $1/3 times 1 - 2/3 times 0.5 = 0$，即是无差异的；
- 假设在信号接收者策略无差异的情况下，信号接收者会选择有利于信号发送者的决策，即这里的企业会选择雇用；
- 故企业期望效用为 0，而根据导师的策略$pi$，导师将全部的优秀学生以及$2/3$的一般学生推荐进入企业，因此导师的期望效用为$0.25 + 0.75 times 2/3 = 0.75$

之后的讨论会严谨说明这一信号是最优的，但现在可以理解这一信号是最
优的直观：
- 优秀的学生应当全部被雇用，然后应当尽可能地让一般的学生被雇用；
- 在上述信号机制中，如果进一步增大一般学生写好推荐信的比例，企业看到好推荐信时会认为一般学生比例太大，因此将倾向于不雇用，因此使得企业雇用和不雇用无差异的信号是最优的。

=== 4.贝叶斯公式

再次回顾贝叶斯公式：设$B$和$A_1,...,A_n$为一系列事件，则有
$ bb(P) (A_k | B) = (bb(P) (A_k, B))/(bb(P) (B)) = (bb(P) (B | A_k) dot bb(P) (A_k))/(sum_(A_i) bb(P) (B | A_i) dot bb(P) (A_i)) $
在贝叶斯劝说的场景下，贝叶斯公式应当表达为：
$ mu_s (omega) = (pi (s|omega) mu_0 (omega))/(sum_(omega^prime in Omega) pi (s | omega^prime) mu_0 (omega^prime)) $
部分诚实推荐策略下给出的后验概率是符合贝叶斯公式的。

== 二、模型描述与问题转化

== 三、最优信号机制 