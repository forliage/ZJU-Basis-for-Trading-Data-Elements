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

*Solution*:

*1.*我们要证明$s^ast=(s_1^ast,s_2^ast,...,s_n^ast)$是一个纳什均衡。根据纳什均衡的定义，我们需要证明对于任何参与人$i$，他都无法通过单方面改变策略来提高收益。也就是要证明：
$ u_i (s_i^ast,s_(-i)^ast)>= u_i (s_i, s_(-i)^ast) quad forall s_i in S_i $
根据题设，对于每个参与人$i$，策略$s_i^ast$是他所有策略中的一个（弱）占优策略。

根据占优策略的定义，对于任何参与人$i$，他的策略$s_i^ast$满足：无论其他参与人选择什么策略组合$s_(-i)$，选择$s_i^ast$的收益总是不会低于选择任何其他策略$s_i$的收益。即：
$ u_i (s_i^ast,s_(-i))>=u_i (s_i, s_(-i)) quad forall s_i in S_i,forall s_(-i) in S_(-i) $
既然这个条件对所有的对手策略组合$s_(-i)$都成立，那么它自然也对$s_(-i)^ast$(即其他参与人选择其各自占优策略的组合) 成立。

因此，我们有：$ u_i (s_i^ast,s_(-i)^ast)>= u_i (s_i, s_(-i)^ast) quad forall s_i in S_i $这个不等式对所有参与人$i in N$都成立。这完全符合纳什均衡的定义。

因此，由每个参与人的占优策略构成的策略组合$s^ast$是一个纳什均衡。

*2.*这个证明包含两部分：a)证明$s^ast$是一个纳什均衡；b)证明这个纳什均衡是唯一的。

*a)*证明$s^ast$是一个纳什均衡

根据严格占优策略的定义，对于任何参与人$i$，他的策略$s_i^ast$满足：无论其他参与人选择什么策略组合$s_(-i)$，选择$s_i^ast$的收益总是严格高于选择任何其他不等于$s_i^ast$的策略$s_i$的收益。即：$ u_i (s_i^ast,s_(-i))>u_i (s_i,s_(-i))quad forall s_i in S_i(s_i!=s_i^ast),forall s_(-i)in S_(-i) $
同样，这个条件对所有的对手策略组合$s_(-i)$都成立，自然也对$s_(-i)^ast$成立。所以：
$ u_i (s_i^ast,s_(-i)^ast)>u_i (s_i,s_(-i)^ast)quad forall s_i in S_i(s_i!=s_i^ast) $
这显然满足纳什均衡的条件$u_i (s_i^ast,s_(-i)^ast)>=u_i (s_i,s_(-i)^ast)$。因此，$s^ast$是一个纳什均衡。

*b)*证明这个纳什均衡是唯一的

我们使用反证法。

假设除了$s^ast=(s_1^ast,...,s_n^ast)$之外，还存在另一个不同的纳什均衡，我们称之为$s^prime=(s_1^prime,...,s_n^prime)$。由于$s^prime=s^ast$，那么必然存在至少一个参与人 $j$，使得他的策略$s_j^prime$与他的严格占优策略$s_j^ast$不同，即$s_j^prime!=s_j^ast$。

现在我们来考察参与人$j$的收益。根据严格占优策略$s_j^ast$的定义，对于任意的对手策略组合$s_(-j)$，选择$s_j^ast$的收益都严格大于选择任何其他策略$s_j^prime$的收益。
$ u_j (s_j^ast, s_(-j))>u_j (s_j^prime,s_(-j))quad forall s_j^prime != s_j^ast,forall s_(-j)in S_(-j) $

这个条件对于对手策略组合$s_(-j)^prime$(即在$s^prime$均衡中，除$j$以外的其他人的策略)也成立。所以，我们有：
$ u_j (s_j^ast,s_(-j)^prime)>u_j (s_j^prime,s_(-j)^prime) $
这个不等式意味着：在其他参与人都选择$s_(-j)^prime$的情况下，参与人$j$如果将自己的策略从$s_j^prime$单方面变更为$s_j^ast$，他的收益将会严格增加。

但这与我们最初的假设"$s^prime$是一个纳什均衡"矛盾。因为根据纳什均衡的定义，任何参与人都不可能通过单方面改变策略来获得更高的收益。

矛盾，故假设是错误的。

因此，不存在其他任何纳什均衡。由每个参与人的严格占优策略构成的策略组合$s^prime$是该博弈的唯一纳什均衡。

证毕！

== 1.2.$N$人古诺竞争

假设在古诺竞争中，一共有$J$家企业。当市场中所有企业总产量为$q$时，市场价格为$p(q)=a - b q$。且每个企业生产单位产品的成本都是同一个常数$c$，即企业$i$的产量为$q_i$时该企业的成本为$c_i (q_i) = c dot q_i$。假设$a > c >= 0, b>0$。

1.求纳什均衡下所有企业的总产量以及市场价格；

2.讨论均衡价格随着$J$变化的情况，你有什么启示？

3.讨论$J -> infinity$的均衡结果，你有什么启示？

*Solution*:

*1.* 企业$i$的利润$pi_i$取决于它自己的产量$q_i$和所有其它企业的总产量$sum_(j!=i)q_j$。
$ pi_i (q_i,q_(-i))=p dot q_i - c dot q_i $
将价格函数$p(q)=a - b (q_i + sum_(j!=i) q_j)$代入:
$ pi_i (q_i, q_(-i)) = [a - b (q_i + sum_(j != i) q_j)] q_i - c q_i $
$ pi_i (q_i, q_(-i)) = a q_i - b q_i^2 - b (sum_(j!=i) q_j) q_i - c q_i $
古诺模型的核心假设是，每个企业在决定自己的产量时，都将其他企业的产量视为给定值。因此，企业$i$会选择$q_i$来最大化其自身利润$pi_i$。我们通过对$pi_i$求关于$q_i$的一阶导数并令其等于0来求解：
$ (partial pi_i) / (partial q_i) = a - 2 b q_i - b sum_(j!=i)q_j - c = 0 $
解得：
$ q_i = (a-c) / (2b) - (1)/(2) sum_(j!=i) q_j $
由于所有企业都有相同的成本函数，我们可以预期一个对称的纳什均衡，即所有企业都生产相同的产量。令此均衡产量为$q^ast$，则$q_i = q^ast$对所有$i$成立。

在这种情况下，其他企业的总产量为$sum_(j!=i) q_j = (J - 1) q^ast$。将其代入最优反应函数：
$ q^ast = (a-c) / (2b) - (1)/(2) (J-1) q^ast $
解得：
$ q^ast = (a-c) / (b(J+1)) $

均衡总产量：
$ Q^ast = J dot q^ast = J dot (a-c)/(b(J+1)) = J/(J+1) (a-c)/(b) $

均衡市场价格：
$ P^ast = a - b Q^ast = (a + c J)/(J + 1) $

*2.* 对$P^ast$求关于$J$的导数：
$ (d P^ast)/(d J) = (c(J+1)-(a+c J))/((J+1)^2)= (c-a)/((J+1)^2) $

由于$c-a<0, (J+1)^2>0$，因此
$ (d P^ast)/(d J) < 0 $

这表明，均衡价格$P^ast$是企业数量$J$的一个递减函数。

启示：市场中的竞争者越多，市场竞争就越激烈，从而导致市场价格越低。
- 当$J=1$(垄断)时，价格为$P^ast = (a+c) / 2$，最高。
- 随着$J$的增加，每个企业所占的市场份额和市场势力都在减小。为了争夺消费者，企业间的价格竞争压力增大，最终拉低了均衡价格。
- 这揭示了市场结构（企业数量）对市场结果（价格）有决定性的影响。增加市场准入和鼓励竞争是降低价格、提高消费者福利的有效途径。

*3.*考察当$J$趋向于无穷大时的极限情况。
$ lim_(J -> infinity) Q^ast= lim_(J -> infinity) ((J)/(J+1) (a-c)/(b))= (lim_(J -> infinity) J/(J+1)) ((a-c)/b)=(a-c)/(b) $
$ lim_(J -> infinity) P^ast=lim_(J ->infinity) (a+c J)/(J + 1)=c $

启示：当市场中的企业数量趋于无穷多时，市场价格趋近于边际成本$c$。
- 这正是完全竞争市场的均衡结果。 在一个完全竞争的市场中，没有企业拥有市场势力，它们都是价格的接受者，长期的均衡条件就是价格等于边际成本，企业的经济利润为零。
- 它表明古诺模型可以看作是连接垄断和完全竞争的桥梁
   - 当 $J=1$ 时，模型描述的是垄断。
   - 当 $J$ 为较小的数时，模型描述的是寡头垄断。
   - 当 $J$ 趋于无穷大时，模型的结果趋同于完全竞争。
- 竞争的程度是决定市场效率的关键。

== 1.3.公地悲剧

假设有$I$个农场主，每个农场主均有权利在公共草地上放牧奶牛。一头奶牛产奶的数量取决于在草地上放牧的奶牛总量$N$：当$N< overline(N)$时，$n_i$头奶牛产生的收入为$n_i dot v(N)$；而当$N >= overline(N)$时，$v(N) equiv 0$。假设每头奶牛的成本为$c$，且$v(0)>c,v'<0,v''<0$，所有农场主同时决定购买多少奶牛，所有奶牛均会在公共草地上放牧(注：假设奶牛的数量可以是小数，也就是无需考虑取整的问题)。

1.将上述情形表达为策略式博弈；

2.求博弈的纳什均衡下所有农场主购买的总奶牛数(可以保留表达式的形式，不用求出具体解)；

3.求所有农场主效用之和最大(社会最优)情况下的总奶牛数(可以保留表达式的形式，不用求出具体解)，与上一问的结果比较，你能从中得到什么启示？

== 1.4.教育作为一种信号

本练习题表明，大学教育除了扩展学生的知识之外，还向未来的雇主传递了一种形式的信号。一个去求
职的年轻人可能是高能力的，也可能是低能力的。假设 1/4 的高中毕业生是高能力的，剩下的是低能
力的。一个新近的高中毕业生，他知道自己是否是高能力的，在申请一份工作之前，可以选择去国外旅
行一年或者进入大学（假定他无法同时做这两件事）。雇主希望雇用一个人填充空缺，但他不知道工作
申请者是否是高能力的；他所知道的仅仅是这个申请者是进入了大学还是去国外旅行了。雇主从雇用
一个工人中所得到的收益，只取决于被雇用工人的能力（而不取决于他的教育水平)，而这个年轻人的
收益取决于高中毕业后做了什么、他的才能（因为高能力的学生更享受学习的过程）以及他是否得到了
这份工作。下面的表格描述了这些收益：

#figure(
  image("/images/image11.png", width: 80%),
) <fig:fig11>

1.将上述博弈表达为一个不完全信息博弈；

2.求出博弈所有的贝叶斯纳什均衡。

== 1.5.混合策略的不完全信息解释

考虑以下抓钱博弈（*grab the dollar*）：桌子上放 1 块钱，桌子的两边坐着两个参与人，如果两人同时去抓钱，每人罚款 1 块；如果只有一人去抓，抓的人得到那块钱；如果没有人去抓，谁也得不到什么。
因此，每个参与人的策略是决定抓还是不抓。

抓钱博弈描述的是下述现实情况：一个市场上只能有一个企业生存，有两个企业在同时决定是否进入。
如果两个企业都选择进入，各亏损 100 万；如果只有一个企业进入，进入者盈利 100 万；如果没有企
业进入，每个企业既不亏也不盈。

1. 求抓钱博弈的纯策略纳什均衡；

#table(
  columns: (1fr,1fr,1fr),
  [],[抓],[不抓],
  [抓],[-1,-1],[1,0],
  [不抓],[0,1],[0,0],
)

2. 求抓钱博弈的混合策略纳什均衡；

现在考虑同样的博弈但具有如下不完全信息：如果参与人$i$赢了，他的利润是$1 + theta_i$(而不是1).这里$theta_i$是参与人的类型，参与人$i$自己知道$theta_i$，但另一个参与人不知道。假定$theta_i$在$[-epsilon, epsilon]$区间上均匀分布。

#table(
  columns: (1fr,1fr,1fr),
  [],[抓],[不抓],
  [抓],[-1,-1],[$1+ theta_1$,0],
  [不抓],[0,$1+ theta_2$],[0,0],
)

由于两个参与人的情况完全对称，故考虑如下对称贝叶斯纳什均衡（两个人的策略相同）形式：参与人$i(i=1,2)$的策略均为

$
s_i(theta_i) = cases(
  "抓，""如果"theta_i >= theta^ast,
  "不抓，""如果"theta_i < theta^ast,
)
$

即$theta^ast$是两个参与人抓或不抓的类型分界阈值，其中$theta^ast$是一个待计算确定的参数。

3.求$theta^ast$;

4.当$epsilon -> 0$时，上述贝叶斯纳什均衡会收敛于什么？从中你能得到怎样的启示。

== 1.6.飞机跑道成本分配的沙普利置计算

机场跑道的维护费用通常是向在那个机场降落飞机的航空公司来收取的。但是轻型飞机所需的跑道长
度比重型飞机所需的跑道长度短，这就带来了一个问题，如何在拥有不同类型飞机的航空公司之间确
定公平的维护费用分摊。

定义一个成本博弈(即每个联盟的效用是成本$(N;c)$，这里$N$是降落在这个机场上的所有飞机的集合，$c(S)$(对于每个联盟$S$)是能够允许联盟中所有飞机降落的最短跑道的维护费用。)如果用沙普利值来确定
费用的分摊，证明：每段跑道的维护费用由使用那段跑道的飞机均摊。

下图描绘了一个例子，其中标号为$A,B,C,D,E,F,G$和$H$的八架飞机每天都要在这个机场降落。每
架飞机所需的跑道的整个长度由图中的区问来表示。例如，飞机$F$需要前三个跑道区间。每个跑道区间的每周维护费用标示在图的下面。例如，$c(A,D,E)=3200,c(A)=2000$和$c(C,F,G)=5100$。在这一
例子中，$A$的沙普利值恰好等于 2000/8 = 250，而$F$的沙普利值等于 2000/8 + 1200/6 + 900/3 = 750。你的任务是将这一性质推广到一般的情形下给出证明（提示：使用沙普利值的性质和公式的特点）。

#figure(
  image("/images/image12.png", width: 80%),
) <fig:fig12>

== 1.7.$epsilon$-贪心算法的遗憾分析

令$epsilon_t = t^(-1/3)(K log t)^(1/3)$，证明：$epsilon$-贪心算法的遗憾界为$O(T^(2/3)(K log T)^(1/3))$。

提示：整体思路是先考虑求任一时刻$t+1$的期望遗憾$bb(E) [R_(t+1)]$，然后对这些遗憾求和，具体步骤如下：

+ 对于时刻$t+1$，注意在前$t$时刻中期望出现$sum_(i=1)^t epsilon_i$次探索，则每个臂被选中的平均次数为$sum_(i=1)^t epsilon_i / K$，然后定义事件$E$为$ |mu_t (a)-Q_t (a)|<= sqrt((K log t) / (sum_(i=1)^t epsilon_i)) $ 则接下来的步骤与课上讲的贪心算法分析类似；
+ 证明任一时刻$t+1$的期望遗憾$bb(E) [R_(t+1)]$满足$ bb(E)[R_(t+1)]<= 3(1/t K log t)^(1/3) + O(t^(-2)) $
+ 将上式从1到$T$求和并放锁得到遗憾界。
