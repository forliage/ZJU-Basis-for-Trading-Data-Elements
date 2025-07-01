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

= Lecture 4:非合作博弈论基础（二）

== 一、混合策略纳什均衡

=== 1.混合策略的引入
纳什均衡是求解博弈的强大工具。然而很可惜的是，仍然存在相当一部分博弈无法找到纳什均衡，甚至是非常常见的博弈，例如石头剪刀布博弈:

#table(
  columns: (1fr,1fr,1fr,1fr),
  [],[石头],[剪刀],[布],
  [石头],[0,0],[1,-1],[-1,1],
  [剪刀],[-1,1],[0,0],[1,-1],
  [布],[1,-1],[-1,1],[0,0],
)

不难验证这个博弈没有纳什均衡——这也符合预期，毕竟石头剪刀布的游戏从来没有一个稳定的策略；
- 考虑简单的情况，例如一个参与人永远出石头，那么另一个人只要观察到这一点，就可以永远出布，这样的情况显然无法构成均衡；
- 所以可以猜想，稳定的策略必定带有随机性，各个参与人要让自己的行为不可捉摸，这就引入了混合策略（mixed strategy）的概念。

=== 2.混合策略

定义：令$G=(N,(S_i)_(i in N),(u_i)_(i in N))$为一个策略型博弈。一个混合策略(mixed strategy)是$S_i$上的概率分布，参与人$i$的混合策略集记为
$ sum_i = {sigma_i : S_i -> [0,1]: sum_(s_i in S_i) sigma_i (s_i) = 1} $
其中$sigma_i (s_i)$表示参与人$i$在该混合策略下选择策略$s_i$的概率。

- 因此混合策略就是给每个$S_i$中的策略（称之为纯策略（pure strategy））一个概率，然后按照这个概率随机选择策略。
- 例如在石头剪刀布博弈中，$(1/3, 1/3, 1/3)$就是一种混合策略，表示每个纯策略（出石头、剪刀和布）被选择的概率都是$1/3$。
- 纯策略是混合策略特例：只有一个策略概率为 1，其余为 0。
- 还有一个记号：对每个参与人$i$，令$Delta (S_i)$为$S_i$上的概率分布集合，即 $ Delta (S_i) = { p: S_i -> [0,1]: sum_(s_i in S_i) p(s_i) = 1} $ 则显然有$sum_i = Delta(S_i)$；
- 当$S_i$是连续策略空间时，求和需要替换为积分，当然本课程不讨论连续策略空间下的混合策略；
- 有混合策略后，博弈中参与人的效用函数也需要做相应的调整，需要适应有混合策略的情况。

=== 3.博弈的混合扩展

定义：令$G=(N,(S_i)_(i in N),(u_i)_(i in N))$为一个策略型博弈。$G$的混合扩展（mixed extension）是一个博弈
$ Gamma = (N, (Sigma_i)_(i in N), (U_i)_(i in N)) $
其中$Sigma_i = Delta (S_i)$是参与人$i$的混合策略集，他的收益函数$U_i:Sigma->bb(R)$将每个混合策略向量$sigma=(sigma_1,...,sigma_n) in Sigma_1 times ... times Sigma_n$映射到一个实数
$ U_i (sigma) = bb(E)[u_i (sigma)] = sum_(s in S) product_(j=1)^n sigma_j (s_j) u_i (s_1,...,s_n) $

- 这里使用了冯诺伊曼-摩根斯坦恩效用函数：每个纯策略$(s_1,...,s_n)$出现的概率为$product_(j=1)^n sigma_j (s_j)$，因此效用的本质是参与人$i$在混合策略向量$sigma$下的期望收益；
- 这里还蕴含一个假定：每个参与人的行动相互独立。

=== 4.混合策略纳什均衡

类似于纯策略纳什均衡，可以给出混合策略纳什均衡的定义：

定义：给定一个博弈的混合扩展$Gamma = (N, (Sigma_i)_(i in N),(U_i)_(i in N))$，一个混合策略向量$sigma^ast = (sigma_1^ast,...,sigma_n^ast)$是一个混合策略纳什均衡，若对每个参与人$i$，有
$ U_i (sigma^ast)>= U_i (sigma_i, sigma_(-i)^ast),forall sigma_i in Sigma_i $
例如，两个参与人都选择混合策略$sigma_1^ast = sigma_2^ast = (1/3,1/3,1/3)$时，$(sigma_1^ast,sigma_2^ast)$构成混合策略纳什均衡；
- 可以尝试根据定义验证这一结果；
- 然而一旦开始验证就会发现上述定义不适合于验证这一结果：因为需要对任意的混合策略$sigma_i$都进行验证，展开后的表达式非常复杂。

因此引入一个更为方便的等价条件方便判断：

混合策略纳什均衡等价条件：令$G=(N,(S_i)_(i in N),(u_i)_(i in N))$为一个策略型博弈，$Gamma$为$G$的混合扩展。一个混合策略向量$sigma^ast$是$Gamma$的混合策略纳什均衡，当且仅当对于每个参与人$i$和每一个纯策略$s_i in S_i$，有 
$ U_i (sigma^ast)>= U_i (s_i, sigma_(-i)^ast) $

证明: 正向推导只需要注意到纯策略也是特殊的混合策略即可。反过来，对于参与人$i$的每个混合策略$sigma_i$， 
$ U_i (sigma_i, sigma_(-i)^ast)=sum_(s_i in S_i) sigma_i (s_i) U_i (s_i, sigma_(-i)^ast)<= sum_(s_i in S_i)sigma_i (s_i) U_i (sigma^ast) = U_i (sigma^ast) $

=== 5.混合策略纳什均衡计算：最优反应

考虑如下性别大战：一对夫妻要安排他们周末的活动，可选择的活动有看足球赛（$F$）和听音乐会（$C$）。丈夫更喜欢看足球赛，而妻子更喜欢听音乐会。如果他们选择的活动不同，那么他们都不会高兴，如果他们选择的活动相同，那么他们都会高兴，只是高兴程度略有不同：

#figure(
  image("/images/image16.png", width: 80%),
) <fig:fig16>

显然 $(F,F)$ 和 $(C,C)$ 是纯策略纳什均衡，但是否存在非纯策略纳什均衡的混合策略纳什均衡呢？

首先展示如何使用最优反应法计算混合策略纳什均衡。记丈夫的混合策略为$(x,1-x)$（表示以$x$的概率选择$F$，$1-x$的概率选择$C$），妻子的混合策略为$(y,1-y)$。对于丈夫的每个混合策略$(x,1-x)$，妻子的最优反应集合为

$
"br"_2 (x) &= arg max_(y in [0,1]) u_2 (x,y) \
          &= {y in [0,1]: u_2 (x,y)>= u_2 (x,z), forall z in [0,1]}
$

而$u_2 (x,y) = x y dot 1 + (1-x) (1 - y) dot 2 = 2 - 2 x - 2 y + 3 x y$，将$x$视为定
值，对$y$求导得到$3 x - 2$，因此可以得到最优反应集合为（丈夫同理）:

$
"br"_2 (x) = cases(
  {0} quad x in [0,2/3),
  [0,1] quad x in {2/3},
  {1} quad x in (2/3,1]
),
"br"_1 (y) = cases(
  {0} quad y in [0, 1/3),
  [0,1] quad y in {1/3},
  {1} quad y in (1/3,1]
)
$

#figure(
  image("/images/image17.png", width: 80%),
) <fig:fig17>

三个交点：$(x^ast,y^ast)=(0,0),(x^ast,y^ast)=(2/3,1/3),(x^ast,y^ast)=(1,1)$，第 1 个
和第 3 个是纯策略纳什均衡，第 2 个是混合策略纳什均衡。

- 求混合策略纳什均衡下双方的对应的收益，你能从中得到什么启示？
- 从上面的图形能看出混合策略纳什均衡具有什么特点？

=== 6.无差异原则

从上述例子中可以看出，混合策略纳什均衡下双方选择策略$F$和$C$的效用是相等的，这一结论可以一般化：

无差异原则：令$sigma^ast$为一个混合策略纳什均衡，$s_i$和$s_i^prime$为参与人$i$的两个纯策略，若$sigma_i (s_i),sigma_i^ast (s_i^prime)>0$，则$U_i (s_i, sigma_(-i)^ast)=U_i (s_i^prime,sigma_(-i)^ast)$。 

定理成立的原因很简单：如果$U_i (s_i, sigma_(-i)^ast) > U_i (s_i^prime, sigma_(-i)^ast)$，那么参与人$i$应该增加$s_i$的概率，这样可以提高自己的收益。

- 被赋予正概率的集合称为混合策略的支撑集合；
- 问题：被严格占优的策略有可能属于混合策略的支撑集合吗；
- 问题：为什么混合策略支撑集的策略无差异，不能只选择其中一个行动或任意选取概率分布？

=== 7.混合策略纳什均衡计算：无差异原则

接下来使用无差异原则计算性别大战的混合策略纳什均衡。使用无差异原
则时首先需要先找到纯策略纳什均衡，否则后续计算可能会忽略。纯策略
纳什均衡显然是$(F,F)$和$(C,C)$。

考虑丈夫的混合策略$sigma_1 = (x,1-x)$和妻子的混合策略$sigma_2 = (y, 1-y)$，且 $0<x<1,0<y<1$（称为完全混合的均衡）。根据无差异原则必有丈夫选择$F$和$C$的效用相等：
$ U_1 (F, sigma_2) = 2 y = 1 - y = U_1 (C, sigma_2) $

解得$y=1/3$，同理可以解得$x=2/3$。因此用无差异原则可以更简便地得到
混合策略纳什均衡。

注意，无差异原则只是取得混合策略纳什均衡的必要条件，并非充分条件，因此求出结果后需要验证。然而本例无需检验，因为本例只有两个策略，两个策略的效用都一致，不存在其他策略得到更高的效用。

=== 8.混合策略纳什均衡的存在性与计算复杂性

尽管并非所有博弈都有纳什均衡，但是下面的纳什定理告诉我们，每个有限的策略型博弈都有至少一个混合策略纳什均衡：

纳什定理：每一个策略型博弈$G$，如果参与人的个数有限，每个参与人的纯策略数目有限，那么$G$至少有一个混合策略纳什均衡。

关于混合策略纳什均衡的计算，根据定义可以转化为线性可行性问题，有指数时间的求解方式（实验要求实现），自然的问题是，是否存在多项式时间的通用解法？答案是，不知道是否存在：

定理：双人博弈纳什均衡的计算是 PPAD 完全问题。

== 二、完全信息动态博弈

=== 1.基本概念

整体博弈被表达为了一棵树，这一类博弈被称为扩展式博弈(extensive-form game)，其中
- 根节点表示博弈的开始，每个叶节点都标志博弈的一个结束点；
- 每个非叶节点上都需要标注这一步的行动者；
- 每个叶节点上需要标注博弈在这一终点下的参与人效用。

扩展式博弈每个参与人的策略是一个向量，表示其在所有可能行动的节点
上的行动。例如蜈蚣博弈中参与人 1 的策略可能是 $(C, C, S, C, …, S, C)$；
即使选定某一策略后博弈停止，也要将此后所有节点的策略都定义好。

一个扩展式博弈的子博弈（subgame）由一个节点$x$和所有该节点的后继
节点组成；实际上就是$x$为根的子树，记为$Gamma (x)$。 

=== 2.完美信息博弈

如果每个参与人在选择行动时，都知道他位于博弈树的哪个节点上，那么这个博弈就是完美信息博弈（game with perfect information），例如蜈蚣博弈，国际象棋等；

但很多博弈不符合这一条件，例如德州扑克或者斗地主等扑克牌游戏，你不知道其他玩家的手牌。

=== 3.子博弈完美均衡

下面介绍完全信息动态博弈的均衡概念，需要扩展普通的纳什均衡概念。

定义：在扩展式博弈$Gamma$中，一个策略向量$sigma^ast$是子博弈完美均衡（subgame perfect equilibrium），如果对于博弈的任意子博弈$Gamma(x)$，局限在那个子博弈的策略向量$sigma^ast$是$Gamma(x)$的纳什均衡：对每个参与人$i$，每个策略$sigma_i$和子博弈$Gamma(x)$，
$ u_i (sigma^ast | x) >= u_i (sigma_i, sigma_(-i)^ast | x) $

这一定义是很直观的，因为如果某个子博弈$Gamma(x)$上参与人存在有利可图的偏离，那么全局来看这也是一个有利可图的偏离。

当一个博弈存在不止一个均衡时，我们希望基于合理的选择标准选择一些均衡，而剔除另一些均衡，这样的一个选择叫做均衡精炼（equilibrium refinements）。子博弈完美均衡是否是纳什均衡的精炼？换言之，是否存在不是子博弈完美均衡的纳什均衡？

=== 4.子博弈完美均衡的例子

#figure(
  image("/images/image18.png", width: 80%),
) <fig:fig18>

+ 这一博弈有两个纯策略纳什均衡：$(A,C)$和$(B,D)$，参与人I更偏好$(B,D)$，参与人II更偏好$(A,C)$；
+ $(A,C)$不是子博弈完美均衡，因为在$x_2$处参与人II存在有利可图的偏离：选择$D$而不是$C$（因此子博弈完美均衡的确是纳什均衡的精炼）；
+ 在 $(A,C)$下，I不会偏离均衡，是因为 II 威胁 I：如果你选择$B$，我就选择$C$，然而这个威胁显然是不可置信的，因为如果 I 选择$B$，那么 II还是选择$D$更有利。

=== 5.子博弈完美均衡的充分条件

例子中$(A,C)$能作为均衡，或者说$c$这一被$d$占优的策略可以成为均衡，是因为$(A,C)$到不了真正要选择$C$, $D$ 的$x_2$点。

用$P_sigma (x)$表示当实施策略向量$sigma$时，博弈展开将造访节点$x$的概率。有如下定理：

定理：令$sigma^ast$是扩展式博弈$Gamma$的纳什均衡，如果对所有$x$都有$P_(sigma^ast)>0$，那么$sigma^ast$是子博弈完美均衡。

- 定理是显然的，因为如果$sigma^ast$不是子博弈完美均衡，那么在某个子博弈$Gamma(x)$上存在有利可图的偏离，并且这个偏离产生的概率不为0，因此也可以带来全局的有利可图的偏离;
- 推论：完全混合的纳什均衡是子博弈完美均衡。

=== 6.逆向归纳法

如何找到完美信息博弈的子博弈完美均衡？直观：要求每个子博弈都是均衡，可以从最小的子博弈出发求解：

#figure(
  image("/images/image19.png", width: 80%),
) <fig:fig19>

从最小的子博弈出发，即$Gamma(x_3)$和$Gamma(x_4)$，选择图中加粗的策略（子博弈
的均衡），然后将均衡结果替代子博弈，逐步向上推导到根节点即可（因
此子博弈完美均衡是$(a e,c)$）

#figure(
  image("/images/image20.png", width: 80%),
) <fig:fig20>

这一方法称为逆向归纳法（backward induction），该方法的应用保证了
每一个子博弈都使用了均衡策略，并且每一步都能做出选择，由此可得：

== 三、不完全信息博弈
