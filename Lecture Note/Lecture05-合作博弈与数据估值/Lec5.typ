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

定义：一个合作博弈$(N;v)$(其中$N={1,2,...,n}$)的核(core)是一个解概念$phi$，其中$phi (N;v)$由满足以下两个条件的分配向量$x = (x_1,x_2,...,x_n)$组成：
+ 有效率的（efficient）：$sum_(i=1)^n x_i = v(N)$，即所有参与者分完了整个联盟的全部收入；
+ 联盟理性（coalitionally rational）：对于任意的$S subset N$，有$sum_(i in S) x_i >= v(S)$，即对于任何联盟而言，他们在大联盟中分配到的收入一定不会比离开大联盟组成小联盟获得的收
入少．

例：求下列三个参与人的合作博弈的核，其中$N={1,2,3}$，特征函数$v$定义如下： 
$ v(Phi) = v({1}) = v({2}) = v({3}) = 0 $
$ v({1,2}) = v({2,3}) = 1, v({1,3})=2, v({1,2,3}) = 3 $

直接设出在核中的向量为$x = (x_1,x_2,x_3)$，并根据核的定义，这一向量应当满足有效率的：
$ x_1 + x_2 + x_3 = v({1,2,3}) = 3 $
以及联盟理性，即：
$ x_1 + x_2 >= v({1,2}) = 1, x_2 + x_3 >= v({2,3}) = 1, x_1 + x_3 >= v({1,3}) = 2, $
$ x_1 >= v({1})=0, x_2 >= v({2}) = 0, x_3 >= v({3}) = 0 $

接下来的关键问题在于如何求出符合上述等式与不等式的所有向量．事实上，有效率性已经
将$x$限制到$bb(R)^3$中的一个平面，然后我们只需将这些不等式约束在这一平面上处理即可．

设核中向量为$x=(x_1,x_2,x_3)$，基于下面这一简单的观察发现核为空集：
+ 根据有效率的，我们有 $ x_1 + x_2 + x_3 = v({1,2,3}) = 1 $
+ 但根据联盟理性，由于$v({1,2}) = v({2,3}) = v({1,3}) = 1$，因此$x_1 + x_2 >= 1, x_2 + x_3 >= 1, x_1 + x_3 >= 1$，于是我们有 $ 2 x_1 + 2 x_2 + 2 x_3 >= 3 $

显然式1与式2是矛盾的，因此这一博弈的核为空集．

== 三、Shapley值计算

=== 1.Shapley 值性质

为了定义出沙普利值，我们首先需要写出沙普利值应当满足的效率和公平性质，然后给出定义并证明其唯一性．为了便于形式化地描述下面的沙普利性质，首先给出如下记号上的定义：

定义：令$phi$为一个单点解，即对于任意的合作博弈$(N;v)$(其中$N={1,2,...,n}$)，$phi (N;v)$都是一个单点集，也就是唯一一个$bb(R)^n$中的向量．我们定义$phi_i (N;v)$为向量$phi (N;v)$中的第$i$个位置的元素，即$phi_i (N;v)$表示参与者$i$在博弈$(N;v)$中的分配到的收入．

定义 (有效率的)：一个解概念$phi$是有效率的（efficiency），若对于任意的合作博弈$(N;v)$（其中$N={1,2,...,n}$），有$sum_(i=1)^n phi_i (N;v) = v(N)$。

即所有参与者分完了整个联盟的全部收入，事实上这与核的要求一致，这一条件是理性参与者一定会希望满足的．

第二个性质是对称性，这一性质是公平性的关键．为了定义对称性，需要首先定义两个参与人什么时候是对称的：

定义 (参与人的对称性)：令$(N;v)$是一个合作博弈，对于$i,j in N$，如果对于任意的$S subset N / {i,j}$，有$v(S union {i}) = v(S union {j})$，则称参与者$i$核$j$是对称的。

用通俗的话说，两个参与人是对称的即对于任何不包含他们的联盟，二者分别加入这一联盟
后，联盟增加的效用（或称边际贡献（marginal contribution））是一致的，因为对称性的定
义等价于$v(S union {i}) - v(S) = v(S union {j}) - v(S)$

定义 (解概念的对称性)一个解概念$phi$是满足对称性（symmetry）的，若对于任意的合作博弈$(N;v)$，如果$i,j in N$是对称的，则$phi_i (N;v) = phi_j (N;v)$．

定义 (零参与者)一个解概念$phi$是符合零参与者（null player）性质的，若对于任意的合作博弈$(N;v)$，如果$i in N$，且对于任意的$S subset N/{i}$，有 $ v(S union {i}) = v(S) $ 则$phi_i (N;v) = 0$

零参与者性质表明，如果一个参与人对于任何联盟的加入都不会增加联盟的效用，即他的边际贡献永远为 0，那么他获得的收入应当为 0．

定义 (解概念的对称性)一个解概念$phi$是满足对称性（symmetry）的，若对于任意的合作博弈$(N;v)$，如果$i,j in N$是对称的，则$phi_i (N;v) = phi_j (N;v)$．

=== 2.Shapley值定义

例 (Shapley 值定义尝试)考虑合作博弈$(N;v)$，其中$N={1,2,...,n}$，我们定义解概念$phi$为
$ phi_i (N;v) = v({1,2,...,i}) - v({1,2,..., i-1}), forall i in N $
习题中要求读者证明这一解概念满足有效率性、零参与者和加性．然而这一解概念不满足对
称性，例如考虑$N={1,2,3}$，特征函数$v$定义如下：
$ v(Phi) = v({1}) = v({2}) = v({3}) = v({1,2}) = v({1,3}) = 0 $
$ v({2,3}) = v({1,2,3}) = 1 $
不难解得这一解概念下的分配向量为${(0,0,1)}$，但是我们很容易发现参与人 2 和 3 在这一
博弈中是对称的，但是$phi_2 (N;v) = != 1 = phi_3 (N;v)$．

这一定义能满足除了对称性以外的所有性质，这时我们心里应当有一个强烈的声音告诉我
们，这里的不对称性来源于强制给定了这$n$个参与人的排序，而不同的排序可能会带来不
同的分配结果，因此自然的想法是：为什么不尝试把所有的排序对应的结果取平均呢？记这$n$个参与人的全体排序构成的集合为$S_n$，根据简单的组合知识可知这一集合中含有$|S_n| = n !$个元素。对于任意排序$sigma in S_n$，定义
$ P_i (sigma) := {j in N | sigma(j) < sigma(i)} $
即在排序$sigma$下位于参与人$i$前面的所有参与人的集合．例如若在排序$sigma$下参与人$i$排在了
第一位，那么$P_i (sigma) = Phi$．

定义：令$(N;v)$是一个合作博弈，其中$N={1,2,...,n}$，参与人$i$的沙普利值定义为
$ S V_(i) (N;v) = 1/(n!) sum_(sigma in S_n) v(P_i (sigma) union {i}) - v(P_i (sigma)) $
即我们将所有排序下前面失败的定义取了平均．

前面的定义基于对不同排列的边际贡献加权平均，我们可以重新整理这一定义，得到基于对
不同联盟的边际贡献的加权平均定义的沙普利值等价定义．假设$i in N$是一个参与者，$S$是
某个不包含$i$的联盟，考虑有多少种排序$sigma$恰好可以使得排在$i$的前面就是$S$，即$P_i (sigma) = S$。这相当于将$n$个参与者分成了三个部分，最前面是$S$，中间是$i$，最后是
$N/(S union {i})$。这三个部分的参与者的相对顺序是确定的，而这三个部分内的参与者的相对顺
序又是可以任意排列的，因此这一情况下的排序数目为$|S|! (n-|S|-1)!$。因此这$|S|! (n - |S| - 1)!$个排列下$P_i (sigma) = S$，基于此我们可以将式3中所有排列按$P_i (sigma)$对应的联
盟组合起来，得到沙普利值的等价定义：

合作博弈$(N;v),N={1,2,...,n}$，则参与人$i$的沙普利值定义为:
$ S V_i (N;v) = 1/(n!) sum_(S subset N / {i}) |S|! (n - |S| - 1)! (v(S union {i}) - v(S)) $

=== 3.留一法

一个自然地想法是使用逆向思维，即为了衡量数据集$D_i$的贡献，可以考虑如果没有数据$D_i$，模型的表现会受到多大的影响，这就是留一法（leave-one-out，简称 LOO）的基本思
想，即基于留一法数据价值$phi_i$的定义如下：
$ phi_i^(L O O) = U(cal(D)) - U(cal(D) / {D_i}) $
即使用所有数据训练出的模型的表现与去掉数据$D_i$后训练出的模型的表现之差．换句话
说，也就是在已有其它数据集的情况下，加入$D_i$后的模型的性能可以提升多少．这一定义
的直观合理性在于，如果数据$D_i$对模型的贡献很大，那么去除数据$D_i$后模型的表现应当
会受到很大的影响，即$phi_i^(L O O)$的值应当较大．

缺陷：若$D_i = D_j$，显然$phi_i^(L O O) = phi_j^(L O O) = 0$，因为当去掉数据$D_i$或$D_j$后训练出的模型因为存
在完全重复的数据，模型表现完全不会受到影响．

=== 4.Data Shapley

数据集$D_i$的Data-Shapley值的定义如下：
$ phi_i^(S h a p) = 1/n sum_(S subset cal(D)/{D_i}) (U(S union {D_i}) - U(S))/(C_(n-1)^(|S|)) $
进一步地，可以考虑将所有$|S|$一致的项合并．令
$ Delta_j (D_i) = 1/(C_(n-1)^j) sum_(S subset cal(D) / {D_i}, |S| = j) (U(S union {D_i}) - U(S)) $
即加入数据集${D_i}$后对所有大小为$j$的联盟的带来的模型训练结果提升的平均值，称为$D_i$对大小为$j$的联盟的边际贡献（marginal contribution）．基于此，Data-Shapley 的定义
可以进一步改写为
$ phi_i^(S h a p) = 1/n sum_(j=0)^(n-1) Delta_j (D_i) $

从这一角度看，数据集$D_i$的 Data-Shapley 值实际上就是$D_i$对所有不同大小的联盟的边际
贡献的平均．也就是说，Data-Shapley 将数据对任意大小联盟的贡献是平等对待的

=== 5.Beta-Shapley

在 Data-Shapley 中，数据对任意大小的联盟的贡献是平等对待的，也就是说，一个数据集
对小的联盟的贡献和对大的联盟的贡献在 Data-Shapley 中具有相同的权重．然而，一个自
然的问题是，当联盟本身已经很大时，此时再加入一个数据集，对联盟的贡献通常而言会比
较小，所以对较大联盟的边际贡献值更容易受到噪声干扰．因此直观上来看，在数据估值
中，如果对较大联盟的边际贡献的权重应当适当缩小，更加重视对较小联盟的边际贡献，可
能对数据集的评估会更加准确．基于此，Beta-Shapley 的定义为
$ phi_i^(B e t a) = 1/n sum_(j=0)^(n-1) hat(omega_j) Delta_j (D_i) $

=== 6.Data-Banzhaf

定义： 
$ phi_i^(b a n z) = sum_(S subset cal(D) / {D_i}) 1/(2^(n-1)) (v(S union {D_i}) - v(S)) $

从 Data-Banzhaf 的表达式中很容易看出其中的思想，事实上就是将$D_i$对所有$2^(n-1)$个联盟$S subset cal(D) / {D_i}$的贡献取平均，而此前 Data-Shapley 对每个单独的联盟的权重与联盟大小有关（为$|S|! (n - |S| - 1)! / n!$），只有将同一大小联盟权重求和才是常数．
和 Beta-Shapley 相比，二者均是 Data-Shapley 的优化，Beta-Shapley 解决了对大联盟边际
贡献噪声大的问题，Data-Banzhaf 是从另一个角度，即针对随机学习算法带来的扰动进行
优化．

=== 7.时间复杂度

- 留一法 $O(n)$
- Data-Shapley, Beta-Shapley, Data-Banzhaf $O(2^n)$ P 完全问题蒙特卡洛采样

=== 8.Dynamic Shapley Value
- Addition: A set of data points $D_(a d d) = {z_(n+1),...,z_m}$ are added to $D$ to form a new dataset $N^+ = D union D_(a d d)$.The Shapley value of $z_i in N^+$ is $ S V_i^+ = 1/(n+m) sum_(S subset N^+ / {i}) (U(S union {i}) - U(S))/(C_(n-1)^(|S|)) $
- Deletion: A subset of data points $D_(d e l) = {z_p,...,z_q} subset D$ are removed from $D$ to form a new dataset $N^- = D / D_(d e l)$. The Shapley value of $z_i in N^-$ is $ S V_i^- = 1/(n+p-q-1) sum_(S subset N^- / {i}) (U(S union {i}) - U(S))/(C_(n+p-q-2)^(|S|)) $

The problem of dynamic Shapley value computation is to compute $(S V_i^+) / (S V_i^-)$ for all the data points in $(N^+)/(N^-)$ efficiently.