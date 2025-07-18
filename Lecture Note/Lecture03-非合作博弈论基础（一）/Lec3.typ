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

= Lecture 3：非合作博弈论基础（一）

== 一、微观经济学基础

===  1.偏好

你现在要组织一场活动，需要为活动配置一些钥匙扣和本子作为奖品，但你不确定买多少个钥匙扣和本子，这时你的心里会出现这样的声音：
- 比起20个钥匙扣和5个本子，我跟喜欢15个钥匙扣和10个本子..；
- 比起15个钥匙扣和10个本子，我更喜欢10个钥匙扣和15个本子；
- ...
  
  在微观经济学中，我们假定消费者在面临选择时，通常首先会对可选方案进行排序，然后从中选择最喜欢的方案。这种排序就体现了消费者的*偏好(preference)*

  事实上，有了偏好之后，就可以衡量物品的价格了：
  - 只需要询问一个诚实的人，例如“你觉得1斤苹果和多少钱带给你的偏好是无差异的”，如此就可以得到一个消费者可以接受的价格；
  - 通过这样的方式，可以为每个消费者的每种消费组合的偏好赋予一个常数，这一常数可以表示为每个消费者对一个消费组合的偏好程度；
  - 例如，为20个钥匙扣和5个本子的组合赋予常数10，为15个钥匙扣和10个本子的组合赋予常数15.。。
  
=== 2.效用

这些常数就称为这些消费组合对消费者产生的效用(utility)。

形式化而言，记$x=(x_1,...,x_n)$表示消费者的消费组合（又称消费约束），其中$x_i$表示购买$x_i$单位物品$i$。

效用函数就是将消费束映射到满意程度的函数：$ u:R^n -> R $

- 设$x$是一个消费束，则$u(x)$是一个实数，表示消费者对$x$的满意程度；
- 如$u$(1斤苹果，-6元钱)=0表示1斤苹果和6元钱对消费者无差异；
- 理性人假设：经济中每个参与人都会选择让自己效用最大化的行动；
   - 当然理性还有其它含义，例如使用贝叶斯公式更新信念；
   - 理性人假设是经济学的理论研究基础，虽然饱受争议（那为什么仍然要考虑理性人的情况呢）；
   - 不理性人的经济学：行为经济学。

=== 3.几类效用函数

- *柯布-道格拉斯效用函数*：$u(x_1,x_2)=x_1^alpha x_2^(1-alpha)$，其中$alpha in (0,1)$表明商品是多多益善的，但具有边际效用递减的特点（之后详细介绍）；现实中常用的效用函数，也可以表达经济投入-产出关系等。

- *冯诺依曼-摩根斯坦效用*：$u(L)=p u(x)+(1-p)u(y)$；如果有一个彩票$L$，购买后有$p$的概率获得$x$，有$1-p$的概率获得$y$，那么购买彩票的效用等于购买$x$和购买$y$的效用的加权平均；$u$是严格凹函数$->$风险厌恶，$u$是严格凸函数$->$风险偏好，$u$是线性函数，$->$风险中性。

- *拟线性效用函数*：$u(x,p)=v(x)-p$。假定每一元钱的效用都是单位1，则上式表示通过价格$p$购买了消费束$x$后的效用；此前的效用函数都是在描述$v$的形式，这里考虑了价格；日后最常见的效用函数。

=== 4.边际效用递减规律

定义：边际效用是指消费者对某种物品的消费量每增加一单位所增加的额外满足程度。

炎炎夏日，如果你想买一些冰激凌解暑，你可能会思考吃几个冰激凌对你而言最满足，于是你计算了一下大致的效用值如下表：
#table(
  columns: (1fr,1fr,1fr,1fr,1fr,1fr,1fr),
  [数量],[1],[2],[3],[4],[5],[6],
  [效用], [7], [12],[16],[18],[15],[10],
)

#table(
  columns: (1fr,1fr,1fr,1fr,1fr,1fr,1fr),
  [数量],[1],[2],[3],[4],[5],[6],
  [边际效用],[7],[5],[4],[2],[-3],[-5],
)

在一定时间内，随着消费某种商品数量的不断增加，消费者从中得到的总效用是在增加的，但是以递减的速度增加的，即边际效用的递减的；当商品消费量达到一定程度后，总效用达到最大轴，如果继续增加消费，总效用不但不会增加，反而会逐渐减少，此时边际效用变为负数。

=== 5.效用最大化问题

预备工作结束后，可以计算一个效用最大化问题，由此研究消费者决策问题的特点。为简化讨论，考虑只有两个商品的情形：设消费者的效用函数为$u(x_1,x_2)$，两种商品的价格分别是$p_1$和$p_2$，消费者的收入为$p$。

这里强调了消费者的收入，这是因为在消费时消费者都有预算约束(budget constraint)，因此效用最大化的目标可以写为：$ max_(x_1,x_2) u(x_1,x_2) "s.t." p_1 x_1 + p_2 x_2 <= p $

要求$u$关于$x_1,x_2$是递增的，则$u$取最大值时预算约束必然取等号。

例：设消费者需要函数为$u(x_1,x_2)=x_1^alpha x_2^beta$，两种商品价格分别为$p_1$和$p_2$，消费者的收入为$p$，求消费者的需求函数。

写出效用最大化函数：$ max_(x_1,x_2) x_1^alpha x_2^beta "s.t."  p_1 x_1 + p_2 x_2 <= p $

- 两种解法：利用预算约束化为一元函数极值问题求解，或使用拉格朗日乘数法
- 不难解得：$ x_1 = (alpha) / (alpha + beta) p / p_1 , x_2 = (beta) / (alpha + beta) p / p_2 $
- 注意这里的效用函数没有考虑钱的效用，而是将钱视为约束
- 不难发现需求与价格之间成反相关关系

=== 6.市场出清

将上述基本思想推广，可以得到一般情况下的消费者需求函数。

*需求定律*：在其它条件不变的情况下，商品的需求量与价格之间成反方向变动的关系，即价格上涨，需求量减少；价格下降，需求量增加。

当然也存在一些例外，例如吉芬商品，但这里不做讨论。

厂商生产决策与消费者决策是类似的，只是考虑利润最大化/成本最小化问题，可以得到如下供给定律：

*供给定律*：对于正常商品来说，在其他条件不变的情况下，商品价格与需求量之间存在着正方向的变动关系，即一种商品的价格上升时，这种商品的供给量就会增加，相反，价格下降时供给量减少，这就是供给定律。

#figure(
  image("/images/image8.png", width: 80%),
  caption: [
    市场出清
  ],
) <fig:fig8>

市场出清（market clearing）：市场机制能够自动地消除超额供给或超额需求，市场在短期内自发地趋于供给等于需求的均衡状态。

上述均衡称为“竞争均衡”，因为其中重要的假设是厂商和消费者数量非常多，以至于他们每个人各自的行动完全无法改变整个市场的价格。
- 例如此前效用最大化问题中假设消费者是价格接受者

=== 7.社会福利

有了竞争均衡的概念后，我们希望知道这样一个市场能自发达到的均衡有多“好”——这是经济学的重要目标之一，因为经济学是研究资源配置的学科，自然我们希望目前这一市场模型能够达到有效资源配置。

资源配置有效性的主要衡量标准依赖于福利（welfare），因此下面讨论消费者、厂商福利以及市场总福利，或者说社会福利的衡量方法。

#figure(
  image("/images/image9.png", width: 80%),
) <fig:fig9>

消费者剩余 = 买到的商品效用 - 支付， 厂商剩余 = 出售的收益 - 成本 

社会福利等于消费者剩余（消费者福利）加上厂商剩余（厂商福利）：消费者剩余和厂商剩余之间的支付被抵消，因此只剩下消费者买到商品的效用 - 厂商成本

#figure(
  image("/images/image10.png", width: 80%),
  caption: [
    社会福利
  ],
) <fig:fig10>

显然在供给曲线和需求曲线相交的位置实现社会福利最大化，这就是福利经济学第一定理的直观结果：

*福利经济学第一定理*：在竞争市场中，当市场供求达到均衡时，市场资源配置是社会福利最大化的。

=== 8.市场失灵

然而现实并非福利经济学第一定理所说的那般美好，因为福利经济学第一定理成立的假设非常多：完全竞争、完全信息、无交易成本、无外部性、无规模经济等，而这些假设在现实中很难实现。在这些条件不满足的时候，就出现了市场失灵（market failure）。

垄断（monopoly）：一个产品只有一家厂商生产，故该厂商具有市场势力，自身可以决定产品价格，从而会破坏完全竞争市场的福利最优性；

垄断厂商会通过提高价格攫取更多的消费者剩余。

外部性（externalities）：外部性指一个人或一群人的行动和决策使另一个人或一群人受损或受益的情况，即社会成员从事经济活动时其成本与后果不完全由该行为人承担；
- 例如河流上游工业园区，下游渔场，工业园区排污会影响渔场的生产活动（负外部性）；
- 例如植树造林不仅美化了环境，还为周围居民提供了清新的空气和休闲场所（正外部性）；
- 植树造林的本质是提供公共物品（public goods），即能够被所有人得到的物品或服务，任何人都不能因为自己的消费而排除他人对该物品的消费（非排他性），类似的例子还有电信、电力、自来水等。公共物品的提供通常会带来正外部性。
   - 但也存在问题：公地悲剧；
   - 产权问题/政府监管。

目前为止几乎所有的讨论都忽视了信息问题：
- 在完全竞争市场中，暗含着假定厂商的成本函数在不同厂商之间是已知的，厂商对消费者的需求曲线也是已知的，消费者对厂商生产的产品带给自己的效用在购买前也是已知的；
- 然而在现实世界中，这些信息通常是不完全的，厂商的成本函数在一些情况下甚至是商业机密，因此不同厂商拥有的成本信息是不同的；对一些新的产品，厂商并不能准确判断市场对其的需求；消费者很多时候也要通过 “货比三家” 的方式来选择最适合自己的产品；
- 这些问题都是信息不对称（asymmetric information）的例子，接下来我们将看到，信息不对称会给资源的有效配置带来很多挑战。

乔治·阿克洛夫（George Akerlof）提出“柠檬市场（The Market for Lemons）”的概念。“柠檬” 在美国俚语中表示 “次品”或 “不中用的东西”，所以柠檬市场也称次品市场。
- 考虑二手车市场，假设市场上有 100 个人在出售二手汽车，还有一系列消费者想要购买二手汽车。已知这些汽车中有 50 辆是好货，还有 50 辆是次货；
- 每辆车的卖家知道它的质量，但买家不清楚且很难直接区分具体某辆车是好货还是次货（信息不称）；
- 次货卖家希望能卖 2000 美元，买家最高支付意愿为 2400 美元；
- 好货卖家希望能卖 3000 美元，买家最高支付意愿为 3600 美元。

- 信息对称时，买家能区分出好货和次货从而选择自己需要的产品；
- 但现在买家无法区分，只知道一半的车是好货，一半的车是次货；
   - 因此买家对一辆车支付意愿不会超过 $1/2 * 2400 + 1/2 * 3600=3000$元；
   - 然而此时好车卖家不愿出售，只能退出市场，留下次货占领整个市场，也就是所谓的“劣币驱逐良币”；
   - 显然这样的市场降低了买卖双方福利，存在市场失灵问题
- 问题：这一市场失灵问题可以如何解决？

类似的例子还有
- 保险中的逆向选择和道德风险问题
- 斯宾塞（Michael Spence）劳动力市场模型
- 阿克洛夫、斯宾塞和斯蒂格利茨（Joseph Stiglitz，贡献在于信息甄别）共同获得 2001 年诺贝尔经济学奖

=== 9.数据的特性
零成本复制性：
- 最直接的一点是，供给曲线失效；
- 外部性：例如你的竞争厂家购买了某份利于提高产量的重要数据，但你没有买，尽管你没有参与市场，但你的利润可能会受到影响；零成本复制使得数据出售更容易，人们更容易受到外部性的影响；
- 公共物品：数据产权问题（类似于创新、专利）；尊重数据劳动成本。

结合垄断和零成本复制性，数据定价可以类比其它信息产品（由比特构成的产品，通常具有零成本复制性），如软件、操作系统、话费等，结合垄断定价可以实施价格歧视（price discrimination）：
- 一级（完全）价格歧视：厂商完全掌握消费者偏好，将每个消费者的价格定在其最大支付意愿上，完全攫取消费者剩余；
- 三级价格歧视：根据消费者一些特征，如年龄、性别、地域等，对不同消费者群体收取不同价格（大数据杀熟，学生半价）；
- 二级价格歧视：先前的思路是收集消费者的信息做出个性化定价，而二级价格歧视是按不同的价格出售不同数量的商品，但购买相同数量产品的人都支付相同的价格；
   - 一种最简单的形式就是，大客户购买的数量比普通客户多，因此可以享受到更低的价格（例如话费）；
   - 更巧妙的策略是设计一系列产品的特定组合，使得不同消费者根据自己的需求选择不同的组合（信息甄别），从而提升整体销量和利润，如机票的商务舱/经济舱，Windows 专业版/家庭版（版本化）等。

效用不确定性（信息不对称）
- 买家确定数据的效用，但卖家不确定买家认为的效用：可能因为买家的下游任务保密，此时需要通过信息显示或甄别的方式解决；
- 卖家知道数据的价值，但买家本身不确定数据效用：买家没看到数据内容前不确定数据质量，可以通过免费试用、打广告（贝叶斯劝说）等方式解决；
- 买家和卖家都不确定数据的效用：结合以上二者，卖家不清楚买家下游任务，买家没看到数据内容前不确定数据质量。

以上问题的解决都将求助于新的研究范式，即基于博弈论的研究范式。

== 二、博弈论：引入与基本概念

=== 1.从微观经济学到博弈论

微观经济学主要关注个人最大化自身效用的单人决策问题，例如消费者最大化效用、厂商最大化利润问题等；完全竞争市场中，消费者无需考虑厂商行动，厂商无需考虑消费者乃至其他厂商行动，就能同时达到自身效用最大化和福利最大化；

然而现实中很多场景下每个人的决策会互相影响，从数学表达式来看，从单人决策到多人相关决策实际上就是从$ max_(x in X) u(x) $
变为了$ max_(x_i in X_i) u(x_i,x_(-i)) $
其中$X$和$X_i$表示决策者的可选决策，$x_(-i)=(x_1,...,x_(i-1),x_(i+1),...,x_n)$表示除$i$之外的其他人的决策，这在博弈论中是常见的记号。

显然，多人决策下的每个人的最优决策都与其他人的最优决策相互交织，因此引入了相当的复杂性。

*例子：垄断与寡头*

假设你是一个书店老板，你的书店是某个小镇上唯一的书店，每本书的成本为20元。你知道每个顾客只要书的价格不超过200元就会买，那么你的决策是什么？这一情况下只有一个厂商，也就是此前提到的垄断的情况。

但如果现在小镇上突然开起了另一个书店，并且每本书的成本也为20元，那么你们的决策是什么？
- 此时有两个厂商，属于寡头垄断(oligopoly)，少数几个厂商的情况都属于寡头垄断
- 上述竞争是价格竞争，称为伯川德竞争(Bertrand competition)，此时两个厂商的最优策略是定价等于成本；
- 后续还会介绍产量竞争场景，称为古诺竞争(Cournot competition)

总结：垄断和寡头垄断下，厂商都具有市场势力，但垄断厂商做决策只需要考虑消费者需求，而寡头垄断厂商则需要考虑其它寡头策略：
- 价格竞争导致利润降为 0，这样的结果双方都很难接受。因此你可以和对方达成协议，共同提高价格，这样双方都能获得正的利润；
   - 然而这样的行为可能会被视为垄断协议，两家书店构成了卡特尔（cartel），这是一种违反反垄断法的行为；
- 但这并不是故事的结局。如果有一天你的好朋友开了一家印刷厂，他可以让你的成本降低到 15 元，结局会如何呢？
   - 显然，你可以将价格定在 19.99 美元，从而将对方挤出市场，而你的利润则会变为 4.99 美元；
   - 总而言之：多人决策的情况复杂性更高。

=== 2.博弈的表达

博弈问题的基本要素？总而言之，是指多个人的交互决策
- 多个人进行决策
- 博弈的行为相互影响

如何规范地表达囚徒困境？

定义：博弈可被表达为一个三元组$G=(N,(S_i)_(i in N),(u_i)_(i in N))$，其中
- 参与人(player)集合：$N$，参与人记为$i in N$,
- 每个参与者可以选择的策略(strategy)集合：$S_i$,
- 报酬函数(payoff function): $u_i:S_1 times ... times S_n -> R$

上述博弈表达称为策略式博弈(straregic game)，更为复杂的博弈(扩展式、不完全信息)还会有其它描述的要素。

要求博弈的参与人是理性且智能的：
- 理性人假设在微观经济学中已经介绍，即参与人会选择最大化自身效用的行动；
- 智能人假设参与人有能力分析博弈的全局；
- 例如在竞争市场中，只要求是理性人，因为只需要最大化自身效用，并不要求对市场的全局有深刻认识；

参与人理性、智能是共同知识。

=== 3.什么是博弈论

总而言之，博弈论（game theory）可以被定义为对智能的理性决策者之间冲突与合作的数学模型研究：

- 博弈论为分析那些涉及两个或更多个参与者且其决策会影响相互间福利水平的情况提供了一般性的数学方法；
- 近代博弈论始于 Zermelo、Borel、Von Neumann、Morgenstern 等人的工作；
- 人类对于如何设计物理系统来控制自然物质已经懂得许多，但对于如何建立社会体制来调节面临冲突的人类行为却做得不够。

=== 4.博弈的解
博弈论的核心：给定一个博弈，关于“将会发生什么，我们能说些什么”。这一问题有至少三种不同可能的解释：
- 经验的、描述性的解释：在给定的博弈中、参与人如何展开博弈；
- 规范的解释：在给定的博弈中，参与人 “应该” 如何展开博弈；
- 理论的解释：假定参与人的行为是 “合理的” 或 “理性的”，那么我们能推测出什么。

第一种解释涉及对参与人实际行为的观察，偏向于心理学与行为经济学的领域；第二种解释适用于仲裁者、立法者等，他们需要根据商定的原则（如公正、效率等）决定博弈的结果；第三种解释则是通过理论方法预期一个博弈的合理结果。

定义：博弈的解或解概念(solution concept)是对于一个博弈的一种预期结果，通常是一个策略组合，即参与人的行动选择，或收益的分配结果。

=== 5.博弈论的分类

非合作博弈：参与人之间没有合作，选择行动之后效用是各自的效用，与他人无关
- 分类依据一：是否完全信息，即参与人之间是否互相知道对方的效用函数，是否知道博弈的全局信息；
- 分类依据二：静态博弈或动态博弈，即参与人的行动是一次同时完成的，还是序贯进行的；
  - 在两个互相看不见的房子里进行石头剪刀布，不要求同时完成，但是行动的先后不会影响结果，因此是静态博弈；
- 四大类博弈：完全信息静态博弈（如囚徒困境）、完全信息动态博弈（如价格领袖模型）、不完全信息静态博弈（如拍卖）、不完全信息动态博弈（如扑克牌）。

合作博弈：考虑参与人之间合作后产生的联合效用
- 重点关注如何分配联合效用，有很多的解概念（收益分配方式）；
- 博弈规范解释的应用（公平分配）；
- 值（在 lec 05 中介绍）。

== 三、占优策略均衡

=== 1.囚徒困境的分析

继续囚徒困境的例子，一个犯罪团伙的两名成员1和2被捕，他们在两个独立的房间里接受审问，他们之间无法通信：
#table(
  columns: (1fr,1fr,1fr),
  [],[不承认],[不承认],
  [不承认],[-1,-1],[-15,0],
  [承认],[0,-15],[-5,-5],
)

理性的参与者会观察到：

罪犯1发现，无论对方选择承认或不承认，自己选择承认都会比不承认效用更高；

罪犯2发现，无论对方选择承认或不承认，自己选择承认都会比不承认效用更高；

这时我们说不承认是一个严格劣策略(strictly dominated stategy)，即无论对方选择什么，自己选择这个策略都是最差的。

=== 2.严格占优

称不承认是一个严格劣策略(strictly dominated strategy)，即无论对方选择什么，自己选择这个策略都是最差的。 

*定义*：给定参与人$i$的策略$s_i$，如果他有另一个策略$t_i$，使得对于任意的$s_(-i) in S_(-i)$，都有$ u_i (t_i, s_(-i)) > u_i (s_i, s_(-i)) $,则称$s_i$是参与人$i$的一个严格劣策略(strictly dominated strategy)。此时称$s_i$被$t_i$严格占优(strictly dominated)，或者说$t_i$严格占优于(strictly dominates)$s_i$。

- 博弈论中假定，理性人不会选择严格劣策略，这并不是一个很强的假设，是符合常识的；
- 在博弈论中，参与人是理性的是共同知识；
- 因此囚徒困境的解(占优策略均衡)是(承认，承认)。 

=== 3.囚徒困境的进一步讨论

*囚徒困境的结果看起来有些不合理？*
- 为什么两个人不会选择更好的点？(理性人的假设)
- 现实中两个人选择合作，原因可能是什么？

*囚徒困境本质*：出于个人理性的决策无法达到社会最优

在完全竞争市场中，每个理性人的自私行为最终会导致整个市场的效率最大化，然而囚徒困境的例子表明现实不可能总是如此美好，人们总要为自己的自私行为付出代价。

*囚徒困境的例子*：公地悲剧、内卷、关税战...($N$人博弈，不止双人)

*解决囚徒困境*：强制力、机制设计、长期关系...

=== 4.重复踢出严格劣策略

博弈论研究的目标之一就是希望拿到一个博弈就能分析清楚其应有的结果，现在有了占优这一工具，我们可以针对部分问题达成目标。

#table(
  columns: (1fr,1fr,1fr,1fr),
  [],[$L$],[$M$],[$R$],
  [$T$],[1,0],[1,2],[0,1],
  [$B$],[0,3],[0,1],[2,0],
)

利用囚徒困境的思想，不难验证，对于参与人2，策略$R$被策略$M$严格占优，因此我们可以剔除策略$R$，得到新的博弈

#table(
  columns: (1fr,1fr,1fr),
  [],[$L$],[$M$],
  [$T$],[1,0],[1,2],
  [$B$],[0,3],[0,1],
)

进一步地，对于参与人1，策略$B$被策略$T$严格占优，因此我们可以剔除策略$B$，得到如下博弈：

#table(
  columns: (1fr,1fr,1fr),
  [$T$],[1,0],[1,2],
)

最后对于参与人2，$L$被$M$严格占优，因此最终的解(占优策略均衡)是($T,M$)。以上过程每一步都剔除一个被占优的策略，故整个过程被称为重复剔除劣策略。

=== 5.弱占优

有的博弈没有严格劣策略，例如：

#table(
  columns: (1fr,1fr,1fr),
  [],[$L$],[$R$],
  [$T$],[1,2],[2,3],
  [$B$],[2,2],[2,0],
)

尽管没有严格劣策略，但策略$B$确实有特殊之处：
- 和策略$T$相比，$B$虽然不能总是给出更好的结果，但至少不会更差；
- 并且在参与人2选择$L$时，策略$B$会给出更好的结果。

这种情况下，我们称策略$B$弱占优于(weakly dominates)策略$T$。

*定义*：给定参与人$i$的策略$s_i$，如果他有另一个策略$t_i$，满足如下两个条件：
- 对于任意的$s_(-i) in S_(-i)$，都有$u_i (t_i, s_(-i)) >= u_i (s_i, s_(-i))$； 
- 至少存在一个$s_(-i) in S_(-i)$，使得$u_i (t_i, s_(-i)) > u_i (s_i, s_(-i))$；

则称$s_i$是参与人$i$的一个弱劣策略(weakly dominated strategy)。此时我们称$s_i$被$t_i$弱占优(weakly dominated)，或者说$t_i$弱占优于(weakly dominated)$s_i$。

- 一般而言，除非强调严格占优，否则默认占优是指弱占优；
- 理性参与人不会使用（弱）劣策略：
  - 可以用于重复剔除劣策略寻找博弈的解，但是比严格劣策略的版本对理性的要求更强；
  - 颤抖的手原则：考虑列参与人分别以$x$和$1-x$的概率选择$L$和$R(0<x<1)$，那么行参与人会选择$B$，因为$T$的期望效用是$x+2(1-x)=2-x$，而$B$的期望效用是2.


重复剔除劣策略的过程中如果只有严格劣策略，那么结果不依赖于剔除的顺序（自行证明），但是剔除弱劣策略的顺序可能会影响结果

== 四、纳什均衡

并非所以博弈都有占优策略，例如：

#table(
  columns: (1fr,1fr,1fr),
  [],[$L$],[$R$],
  [$T$],[2,1],[2,-20],
  [$M$],[3,0],[-10,1],
  [$B$],[-100,2],[3,3],
)

- 可以换一个角度考虑：如果一个参与人已知他人使用的策略，那么他参加的博弈实际上就是要选择一个“最佳应对”；
- 考虑策略组合($B,R$)，此时每个人都不愿意单独偏离这一组合，因为$B$和$R$各自是对方的最佳应对；
  - 也就是说，如果其它参与人确实根据($B,R$)选择了策略，那么每个人都不愿意单独偏离这一组合，所以这一策略组合是稳定的。
  
将前述直观转化为严谨的表达：

*定义*：令$s_(-i)$为参与人$i$之外的所有参与人的策略组合，参与人$i$的策略是$s_i$是$s_(-i)$的一个最佳应对(best response)，如果满足$ u_i (s_i,s_(-i))=max_(t_i in S_i) u_i (t_i,s_(-i)) $

基于此，可以定义博弈论中最为核心的解概念——纳什均衡：

*定义*：一个策略组合$s^*=(s_1^*,...,s_n^*)$是一个纳什均衡(Nash equilibrium)，如果对于每个参与人$i$，$s_i^*$是$s_(-i)^*$的一个最佳应对。

基于最优反应的定义通常用于计算纳什均衡，下面这一纳什均衡的等价定义在表达上更为直接：

*定义*：一个策略组合$s^*=(s_1^*,...,s_n^*)$是一个纳什均衡，如果对于每个参与人$i$和任意的策略$s_i in S_i$都有$ u_i (s^*)>= u_i (s_i,s_(-i)^*) $

- 如果$u_i (hat(s_i), s_(-i))> u_i (s)$，那么策略$hat(s_i)$是参与人$i$有利可图的策略偏离，因此纳什均衡的策略向量不允许存在有利可图的策略偏离；
- 因此纳什均衡的合理性直观就是这一策略组合是“稳定的”；
- 通过这一理解可以很容易明白为什么上述定义与此前基于最优反应的定义是等价的。

=== 连续策略求解：古诺竞争

两家制造商1和2生产相同的产品，在同一市场中竞争潜在的顾客。两家制造商同时选择产量，总产量决定产品的市场价格，市场价格对两家企业而言是相同的。用$q_1$和$q_2$分别表示两家企业的产量，因此$q_1 + q_2$是市场的总产量。假设供给为$q_1 + q_2$时，每件产品的价格为$2 - q_1 - q_2$。假设两家厂商的单位生产成本分别为正实数$c_1,c_2$，试求解这一博弈的纳什均衡。

博弈定义：两个博弈，每个参与人的策略集合是$[0,+ infinity)$，如果参与人1选择策略$q_1$，参与人2选择策略$q_2$，那么参与人1的效用(利润)是 $ u_1 (q_1,q_2)=(2-q_1-q_2)q_1 - c_1 q_1 = q_1 (2-q_1 -q_2 - c_1) $
参与人2的效用是$ u_2 (q_1,q_2) = q_2 (2-q_1-q_2-c_2) $

使用最优反应的定义求解纳什均衡，首先求参与人1关于$q_2$的最优反应$R(q_2)$，即将最大化$u_1 (q_1, q_2)$的$q_1$定义为$R(q_2)$: $ (partial u_1) / (partial q_1) = 2 - 2q_1-q_2-c_1=0 $
解得$ R(q_2)= (2-q_2-c_1) / 2 $
注意$u_1 (q_1,q_2)$关于$q_1$是凹函数，因此一阶条件得到的是最大值点，同理对于参与人2，可以解得$ R(q_1) = (2-q_1-c_2) / 2 $
联立上述方程解得：$ q_1^*= (2-2c_1+c_2)/3 , q_2^*= (2-2c_2+c_1) / 3 $
不难看出，在均衡中，自己的成本越高，均衡产量越低；对方的成本越高，会导致对方均衡产量降低，从而给自己提高产量的机会。因此这一结果是非常符合直观的。

目标不只是解出均衡，而是通过解看出模型是否符合现实，对于现实情况有什么参考价值。

== 补充：对于纳什定理的证明

*定理陈述*：若参与者有限，每位参与者的策略有限，收益函数为实值函数，则博弈必存在混合策略意义下的纳什均衡（纯策略NE可看作特例）。

*第一步：定义*：

1.*Players*：设有一个有限的参与者集合$I={1,2,...,n}$，其中$n>= 1$是参与者的数量。

2.*Pure Strategy Sets*：对于每个参与者$i in I$，存在一个有限的纯策略集合$ S_i={s_("i1"),s_("i2"),...,s_("im"_i)} $，其中$m_i=|S_i|$是参与者$i$可选择的纯策略的数量。一个pure strategy profile是$s=(s_1,s_2,...,s_n)$，其中$s_i in S_i$。所有可能的纯策略组合的空间是$S=S_1 times S_2 times ... times S_n$

3.*Payoff Functions*：对于每个参与者$i in I$，其收益函数为$u_i:S -> R$。这意味着给定一个纯策略组合$s in S$，参与者$i$得到一个实数值的收益$u_i (s)$。

4.*Mixed Strategies*：一个参与者$i$的混合策略$sigma_i$是对其纯策略$S_i$的一个概率分布。即，$ sigma_i=(sigma_i (s_("i1")),sigma_i (s_("i2")),...,sigma_i (s_("im"_i))) $，其中：
  - $sigma_i(s_("ik"))>= 0$对于所有$k=1,...,m_i$（表示选择纯策略$s_{"ik"}$的概率）
  - $sum_(k=1)^(m_i) sigma_i (s_("ik"))=1$

  参与者$i$的所有混合策略的集合记为$Delta_i$。$Delta_i$是一个$m_i -1$维的标准simplex。

  *性质*：每个$Delta_i$都是欧几里得空间$R^(m_i)$中的一个紧致（compact，即闭合且有界）和凸（convex）集。

5.*Mixed Strategy Profile*：一个混合策略组合是$sigma=(sigma_1,sigma_2,...,sigma_n)$，其中$sigma_i in Delta_i$。所有可能的混合策略组合的空间是$Delta=Delta_1 times Delta_2 times ...times Delta_n$。由于每个$Delta_i$都是compact and convex，所以它们的笛卡尔积$Delta$也是一个compact and convex set。

6.*Expected Payoff*：当参与者选择混合策略组合$sigma=(sigma_1,...,sigma_n)$时，参与者$i$的期望收益$U_i (sigma)$定义为：
$ U_i(sigma)=sum_(s in S)(product_(j=1)^n  sigma_j (s_j))u_i (s) $
其中$sigma_j (s_j)$是参与者$j$选择其纯策略$s_j$的概率。求和遍历所有可能的纯策略组合$s=(s_1,...,s_n) in S$。期望收益函数$U_i:Delta -> R$。

*性质*：$U_i (sigma)$是关于每个$sigma_j$的multilinear function，因此它是关于$sigma$的连续函数。

7.*Definition for Nash Equilibrium*：一个混合策略组合$sigma^*=(sigma_1^*,...,sigma_n^*)in Delta$是一个纳什均衡，如果对于每个参与者$i in I$和所有可能的其它混合策略$sigma_i in Delta_i$都满足：
$ U_i (sigma_i^(*),sigma_(-i)^(*))>= U_i (sigma_i,sigma_(-i)^*) $
这里$sigma_(-i)^*=(sigma_1^*,...,sigma_(i-1)^*,sigma_(i+1)^*,...,sigma_n^*)$表示除参与者$i$之外的其它所有参与者的策略组合。这个定义意味着，在纳什均衡状态下，没有任何一个参与者可以通过单方面改变自己的策略来获得更高的期望收益。

下面给出性质的证明：

记$ p_k=sigma_i(s_("ik"))$。$ Delta_i={(p_1,...,p_(m_i)) in R^{m_i}|p_k>= 0,sum_(k=1)^(m_i) p_k = 1} $是标准$(m_i - 1)$-simplex定义。

*先证明$Delta_i$是紧致的*

在欧几里得空间$R^{m_i}$中，一个集合是紧致的当且仅当它是closed and bounded（Heine-Borel定理）。我们分别证明这两点：

1.证明$Delta_i$是Bounded：

对于任何$sigma_i=(p_1,...,p_(m_i))in Delta_i$，我们有$0<= p_k<=1$对所有$k=1,...,m_i$。这意味着$Delta_i$包含在$R^{m_i}$中的单位超立方体
$ [0,1]^(m_i)={(x_1,...,x_(m_i))in R^(m_i)|0<= x_k <= 1} $
的一个子集内。
单位超立方体$[0,1]^(m_i)$本身是有界的。例如，对于其中任何一点$x$，其欧几里得范数$ |x|=sqrt(sum x_k^2)<= sqrt(m_i) $。由于$Delta_i$是有界集合的子集，所以它本身也是有界的。

2.证明$Delta_i$是closed：

一个集合是closed，如果它包含所有的极限点，或者说，如果一个序列中的所有点都在该集合中，并且该序列收敛，则其极限点也在该集合中。我们也可以通过定义$Delta_i$的函数来证明：

考虑函数$f_k:R^{m_i}-> R$定义为$f_k (p_1,...,p_m) = p_k$对于$k=1,...,m_i$。这些函数是连续的。条件$p_k>= 0$可以写成$f_k (p)>= 0$。集合$C_k={p in R^(m_i)|f_k(p)>= 0}$是closed，因为它是闭区间$[0,infinity)$在连续函数$f_k$下的原像。考虑函数$g:R^(m_i)->R$定义为$g(p_1,...,p_(m_i))=sum_(k=1)^(m_i) p_k$。这个函数是连续的。条件$sum_(k=1)^(m_i)p_k = 1$可以写成$g(p)=1$。集合$C_("sum")={p in R^(m_i)|g(p)=1}$是闭合的，因为它是单点集合${1}$在连续函数$g$下的原像。
注意到
$ Delta_i=( sect.big_(k=1)^(m_i) C_k)sect C_{"sum"} $
由于有限个闭集的交集仍然是闭集，因此，$Delta_i$是closed。

*下面证明$Delta_i$是Convex的*

令$sigma_i^A=(p_1^A,...,p_(m_i)^A)in Delta_i,sigma_i^B=(p_1^B,...,p_(m_i)^B)in Delta_i$是$Delta_i$中的任意两个混合策略。取任意一个实数$lambda in [0,1]$，构造一个新的点$sigma_i^C=lambda sigma_i^A+(1- lambda) sigma_i^B$。其第k个分量是$p_k^C=lambda p_k^A+(1- lambda) p_k^B$。

1.验证非负性（$p_k^C>= 0$）：这是显然的。

2.验证概率和为1：
$ sum_(k=1)^(m_i)p_k^C=lambda(sum_(k=1)^(m_i) p_k^A)+(1-lambda)(sum_(k=1)^(m_i)p_k^B)=1 $

由此可知成立。

*第二步：Lemma:Brouwer's Fixed-Point Theorem*

令$X$是欧几里得空间$R^k$中的一个非空、紧致、凸子集。令$f:X-> X$是一个连续函数。则$f$必存在一个不动点，即存在一点$x^* in X$使得$f(x^*)=x^*$

下面给出此定理的证明：

*Sperner's Lemma*：

定义：

*$n$-simplex*：在$R^{n+1}$空间中，一个标准的$n-$单纯形$Delta^n$是由$n+1$个仿射无关的顶点$v_0,v_1,...,v_n$生成的凸包。通常，我们可以取标准顶点
$$v_0=(1,0,...,0),v_1=(0,1,0,...,0),...,v_n=(0,...,0,1)$$
任何点$x in Delta^n$都可以唯一地表示为$x=sum_(i=0)^n lambda_i v_i$，其中$lambda_i>= 0$且$sum_(i=0)^n lambda_i =1$。这些$lambda_i$称为$x$的重心坐标。一个$k-$维面是由$k+1$个顶点的子集生成到凸包。

*Triangulation*：对$n$-单纯形$S$的一个单纯剖分$T$是指将$S$分解为有限个小的$n-$单纯形（称为子单纯形），使得：
- 所有小的单纯形的并集等于$S$
- 任意两个小单纯形的交集要么是空集，要么是它们共同的一个面（任意维度）。

*Sperner Labeling/Proper Labeling*：给定$n-$单纯形$S="conv"{v_0,v_1,...,v_n}$及其一个单纯剖分$T$。对剖分$T$中的每一个顶点（这些顶点包括$S$的原始顶点以及剖分产生的新顶点），我们赋予一个来自集合${0,1,...,n}$的标号。这个标号被称为Sperner标号，如果它满足以下条件：
- $S$的原始顶点$v_i$被标号为$i$（即$L(v_i)=i$）
- 如果剖分中的一个顶点$w$位于$S$的一个$k-$维面$"conv"{v_(i_0),v_(i_1),...,v_(i_k)}$上，那么$w$的标号$L(w)$必须是${i_0,i_1,...,i_k}$中的一个。

*Fully Labeled  Simplex/Panchromatic Simplex*：在单纯剖分$T$中，如果一个小$n-$单纯形的$n+1$个顶点恰好被赋予了所有$n+1$个不同的标号${0,1,...,n}$，则称这个小单纯形是全标号的。

*Sperner Lemma*：对于任意$n-$单纯形$S$及其任意单纯剖分$T$和任意Sperner Label，剖分$T$中全标号的小$n-$单纯形的数量至少为1，且为奇数。

证明：

使用数学归纳法。

$n=0$：一个0-单纯形$S={v_0}$。它只有一个顶点$v_0$。单纯剖分$T$只有$v_0$本身。Sperner Label要求$L(v_0)=0$。这个0-单纯形本身就是全标号的（因为它用了标号集${0}$中的所有标号）。数量为1，是奇数。

$n=1$:一个1-单纯形$S="conv"{v_0,v_1}$是一条线段。$L(v_0)=0,L(v_1)=1$。单纯剖分$T$将线段$S$分为若干小线段$s_j="conv"{w_j,w_(j+1)}$。其中$w_0=v_0,w_m=v_1$。根据Sperner标号条件，剖分中的任何顶点$w$只能被标号为0或1.一个全标号的1-单纯形（小线段）是指两个端点分别被标号为0或1。考虑到$w_0(L(w_0)=0)$开始沿着线段向$w_m(L(w_m)=1)$移动。我们观察标号序列$L(w_0),L(w_1),...,L(w_m)$。令$N_(01)$为标号为$(0,1)$或$(1,0)$的小线段数量。考虑所有小线段端点标号为0的个数。每个标号为$(0,0)$的小线段贡献两个0，每个标号为$(0,1)$或$(1,0)$的小线段贡献一个0一个更直观的“门”论证：
    考虑标号为0的顶点。$v_0$ 的标号是0。在线段 $S$ 上，如果一个小线段的一个端点是0，另一个是1，我们就说这个小线段是一个“门”。
    从 $v_0$ 开始，标号为0。如果 $L(w_1)=0$，则 $[w_0, w_1]$ 不是全标号的。如果 $L(w_1)=1$，则 $[w_0, w_1]$ 是全标号的。
    设 $k$ 是具有标号 (0,1) 的小单纯形的个数。
    设 $P_0$ 是所有剖分顶点中标号为0的顶点集合。
    每个全标号小线段 $[w_j, w_(j+1)]$ （不妨设 $L(w_j)=0, L(w_(j+1))=1$）有一个标号为0的端点。
    考虑标号为0的顶点，并计算它属于多少个全标号小线段：
    $v_0$ ($L(v_0)=0$)：如果 $L(w_1)=1$，则 $[v_0,w_1]$ 是全标号的，$v_0$ 属于1个。
    $v_1$ ($L(v_1)=1$)：不以0开头。
    内部顶点 $w_j$ ($0<j<m$):
    如果 $L(w_j)=0$：
    若 $L(w_(j-1))=1, L(w_(j+1))=1$，则 $w_j$ 属于2个全标号小线段。
    若 $L(w_(j-1))=0, L(w_(j+1))=1$，则 $w_j$ 属于1个全标号小线段。
    若 $L(w_(j-1))=1, L(w_(j+1))=0$，则 $w_j$ 属于1个全标号小线段。
    若 $L(w_(j-1))=0, L(w_(j+1))=0$，则 $w_j$ 属于0个全标号小线段。
    更清晰的论证是统计“0-1转换”的次数。序列从0开始到1结束，则从0变到1的次数比从1变到0的次数多1。所以 (0,1) 小线段的个数是奇数。

$n-1-> n$:
    假设引理对于 $n-1$ 维成立。我们要证明它对于 $n$ 维也成立。
    考虑一个 n-单纯形 $S = "conv"{v_0, ..., v_n}$ 及其剖分 $T$ 和斯珀纳标号 $L$。
    一个 (n-1)-维面如果其顶点标号恰好是 ${0, 1, ..., n-1}$，我们称之为一个“门”。
    考虑剖分 $T$ 中的任何一个小 n-单纯形 $sigma$。
       如果 $sigma$ 是全标号的，即其顶点标号为 ${0, 1, ..., n}$。那么它恰好有一个 (n-1)-维面其顶点标号为 ${0, 1, ..., n-1}$ (这个面与标号为 $n$ 的顶点相对)。所以 $sigma$ 有1个门。
       如果 $sigma$ 的顶点标号包含 ${0, 1, ..., n-1}$，并且还包含一个来自 ${0, 1, ..., n-1}$ 的重复标号（比如标号为 $k in {0, ..., n-1}$ 的顶点出现了两次，而标号 $n$ 没有出现）。那么 $sigma$ 将会有两个 (n-1)-维面其顶点标号为 ${0, 1, ..., n-1}$。所以 $sigma$ 有2个门。
      如果 $sigma$ 的顶点标号不包含完整的集合 ${0, 1, ..., n-1}$（例如，缺少某个标号 $j in {0, ..., n-1}$，或者标号 $n$ 出现了多次），那么 $sigma$ 将有0个门。

现在，我们来数总共有多少个门，通过两种方式：
    1.  *内部的门：* 如果一个 (n-1)-维面 $tau$ 是两个小 n-单纯形 $sigma_1$ 和 $sigma_2$ 的公共面，并且 $tau$ 是一个门。那么这个门被数了两次（一次为 $sigma_1$ 的门，一次为 $sigma_2$ 的门）。
    2.  *边界上的门：* 如果一个 (n-1)-维面 $tau$ 位于 $S$ 的边界上，并且 $tau$ 是一个门。这样的 $tau$ 只属于一个内部的小 n-单纯形。

设 $N_("full")$ 是全标号小 n-单纯形的数量。
设 $N_("rep")$ 是那种顶点标号包含 ${0, ..., n-1}$ 并有一个重复标号（来自 ${0, ..., n-1}$）的小 n-单纯形的数量。
设 $N_("other")$ 是其他类型的小 n-单纯形的数量。
    总的“门-单纯形关联数” (sum of doors per simplex) 是 $1 times N_("full") + 2 times N_("rep") + 0 times N_("other") = N_("full") + 2N_("rep")$。

现在考虑 $S$ 的边界。一个 (n-1)-维面 $tau$ 是一个门，当且仅当它的顶点标号为 ${0, 1, ..., n-1}$。
    这样的 $tau$ 必须位于 $S$ 的那个由 ${v_0, ..., v_(n-1)}$ 张成的面 $F_n = "conv"{v_0, ..., v_{n-1}}$ 上。因为如果 $tau$ 位于其他任何边界 面 $F_j = "conv"{v_0, ..., v_(j-1), v_(j+1), ..., v_n}$ 上 (其中 $j <= n$)，那么 $F_j$ 上的所有顶点的标号都不能是 $j$（根据斯珀纳标号条件，顶点在 $F_j$ 上则其标号来自 ${0, ..., j-1, j+1, ..., n}$）。因此，它不可能包含所有标号 ${0, ..., n-1}$ （如果 $j in {0, ..., n-1}$）。
    只有 $F_n$ 上的 $(n-1)$-维面才可能具有 ${0, ..., n-1}$ 的标号。
    面 $F_n$ 是一个 $(n-1)$-单纯形，其顶点是 $v_0, ..., v_(n-1)$。其上的剖分和标号构成了一个 $(n-1)$-维的斯珀纳标号问题。根据归纳假设，面 $F_n$ 上全标号的 $(n-1)$-维小单纯形（即门）的数量是奇数。令这个奇数为 $N_("boundary_doors")$。

由于内部的门都被数了两次（偶数次），而边界上的门只被数了一次，所以：
    $N_("full") + 2N_("rep") equiv N_("boundary_doors") mod 2$
    因为 $2N_("rep")$ 是偶数，而 $N_("boundary_doors")$ 是奇数（根据归纳假设），所以：
    $N_("full") mod 2 equiv "奇数" mod 2$
    因此，$N_("full")$ 必须是奇数。
    由于奇数必然 $>= 1$，所以至少存在一个全标号的小 n-单纯形。
    归纳完成。

*下面证明Brouwer不动点定理*

假设 $f(x) != x$ 对所有 $x in Delta^n$ 成立。
对于 $Delta^n$ 中的任意点 $x=(x_0, x_1, ..., x_n)$（这里用重心坐标，$sum x_i = 1, x_i >= 0$），令 $f(x) = (y_0, y_1, ..., y_n)$（同样是重心坐标，$sum y_i = 1, y_i >= 0$）。
由于 $f(x) != x$，则 $x_i != y_i$ 至少对某个 $i$ 成立。
*关键断言：* 如果 $f(x) != x$，那么必定存在某个指标 $j in {0, 1, ..., n}$ 使得 $x_j > y_j$ (即 $x_j > f_j (x)$，这里 $f_j (x)$ 是 $f(x)$ 的第 $j$ 个重心坐标)。
   证明此断言：假设对所有 $i$ 都有 $x_i <= y_i$。如果存在某个 $k$ 使得 $x_k < y_k$，那么 $sum x_i < sum y_i$。但是 $sum x_i = 1$ 且 $sum y_i = 1$，所以 $1 < 1$，矛盾。因此，如果对所有 $i$ 都有 $x_i <= y_i$，则必然对所有 $i$ 都有 $x_i = y_i$，即 $x= f(x)$，但这与我们的假设 $f(x) != x$ 矛盾。所以，假设不成立，即必定存在某个 $j$ 使得 $x_j > y_j$。

现在，我们为 $Delta^n$ 中的每个点 $x$ 定义一个标号 $L(x)$ 如下：
$L(x) = min { j in {0, 1, ..., n} mid x_j > f_j(x) }$
这个标号是明确定义的，因为我们证明了这样的 $j$ 总是存在。

我们需要验证此标号 $L$ 满足斯珀纳标号的条件，对于 $Delta^n$ 的任意单纯剖分 $T$。
   *条件1 (原始顶点标号)：* 考虑 $Delta^n$ 的原始顶点 $v_i$。其重心坐标是 $x_i=1$ 且 $x_j=0$ 对 $j != i$。
    如果 $L(v_i) = k != i$，那么意味着 $ (v_i)_k > f_k(v_i) $。但是 $(v_i)_k = 0$ (因为 $k != i$)。所以 $0 > f_k (v_i)$。但 $f_k(v_i)$ 是 $f(v_i)$ 的一个重心坐标，所以 $f_k(v_i) >= 0$。这导致 $0 > "非负数"$，矛盾。
    因此，必须有 $(v_i)_i > f_i(v_i)$，即 $1 > f_i(v_i)$（这是可能的）。并且对于 $j < i$，如果 $(v_i)_j > f_j(v_i)$ 成立，那将是 $0 > f_j(v_i)$，矛盾。
    所以 $L(v_i)=i$。 (这里有一个细微之处，$min$ 的定义使得我们选择最小的 $j$。我们需要确保 $L(v_i)=i$。如果 $v_i$ 的标号是 $k < i$，则 $(v_i)_k > f_k (v_i)$, 即 $0 > f_k (v_i)$, 矛盾。所以标号不可能是 $<i$。那么它是否可能是 $>i$? 即 $(v_i)_i <= f_i (v_i)$ 并且对某个 $k>i$, $(v_i)_k > f_k (v_i)$? 后者意味着 $0 > f_k (v_i)$, 矛盾。所以必须是 $(v_i)_i > f_i (v_i)$, 并且 $i$ 是满足此条件的最小下标。因此 $L(v_i)=i$。)

   *条件2 (面上的顶点标号)：* 设 $w$ 是剖分 $T$ 中的一个顶点，它位于 $Delta^n$ 的一个面 $F = "conv"{v_{i_0}, ..., v_{i_k}}$ 上。这意味着 $w$ 的重心坐标 $w_j = 0$ 如果 $j in.not {i_0, ..., i_k}$。
    如果 $L(w) = l$，那么根据定义，$w_l > f_l(w)$。由于 $f_l(w) >= 0$ (作为重心坐标)，则 $w_l > 0$。
    一个坐标 $w_l > 0$ 意味着 $l$ 必须是张成面 $F$ 的原始顶点下标之一，即 $l in {i_0, ..., i_k}$。
    这正是斯珀纳标号的第二个条件。

既然我们构造的标号 $L$ 是一个斯珀纳标号，我们可以考虑一系列对 $Delta^n$ 的单纯剖分 $T_m$ ($m=1, 2, ...$)，使得当 $m -> infinity$ 时，剖分中小单纯形的最大直径趋向于0。

对于每个剖分 $T_m$，根据斯珀纳引理，至少存在一个全标号的小 n-单纯形 $sigma_m$。设 $sigma_m$ 的顶点为 $w_0^((m)), w_1^((m)), ..., w_n^((m))$，使得 $L(w_j^((m))) = j$ 对所有 $j=0, ..., n$。
根据标号 $L$ 的定义，$L(w_j^((m))) = j$ 意味着：
$(w_j^((m)))_j > f_j(w_j^((m)))$ （即 $w_j^((m))$ 的第 $j$ 个坐标大于 $f(w_j^((m)))$ 的第 $j$ 个坐标）。
并且，对于 $k < j$，$(w_j^((m)))_k <= f_k(w_j^((m)))$。

由于 $Delta^n$ 是紧致的，序列 ${w_0^((m))}_(m in N)$ (作为 $Delta^n$ 中的点序列) 必有收敛子序列。由于 $sigma_m$ 的所有顶点 $w_0^((m)), ..., w_n^((m))$ 都属于同一个小单纯形 $sigma_m$，且 $sigma_m$ 的直径趋于0，所以如果一个顶点序列收敛，那么所有这些顶点序列都收敛到同一点。
因此，存在一个点 $x^* in Delta^n$ 和一个子序列（我们仍用 $m$ 表示）使得 $w_j^((m)) -> x^*$ 对所有 $j=0, ..., n$ 都成立，当 $m -> infinity$ 时。

由于函数 $f$ 是连续的，其坐标分量 $f_j$ 也是连续的。
所以，对于每个 $j in {0, ..., n}$：
当 $m -> infinity$ 时，$(w_j^{(m)})_j -> x_j^*$。
当 $m -> infinity$ 时，$f_j(w_j^((m))) -> f_j(x^*)$。

由不等式 $(w_j^((m)))_j > f_j(w_j^((m)))$，取极限得到：
$x_j^* >= f_j(x^*)$ 对所有 $j=0, ..., n$ 成立。 (1)

同时，对于 $L(w_j^((m))) = j$ 的定义，我们还有 $(w_j^((m)))_k <= f_k(w_j^((m)))$ 对所有 $k < j$。
取极限得到：
$x_k^* <= f_k(x^*)$ 对所有 $k < j$ 成立。(2)

从 (1) 我们知道 $x_j^* >= f_j(x^*)$ 对所有 $j$ 成立。
由于 $x^* in Delta^n$ 和 $f(x^*) in Delta^n$，我们有 $sum_(j=0)^n x_j^* = 1$ 和 $sum_(j=0)^n f_j(x^*) = 1$。
如果存在任何一个 $k$ 使得 $x_k^* > f_k(x^*)$，那么为了保持总和为1，必然存在至少一个 $l$ 使得 $x_l^* < f_l (x^*)$。
但是 (1) 表明 $x_j^* >= f_j(x^*)$ 对所有 $j$ 成立，这意味着不存在 $l$ 使得 $x_l^* < f_l  (x^*)$。
因此，唯一可能性是 $x_j^* = f_j (x^*)$ 对所有 $j=0, ..., n$ 都成立。
这意味着 $x^* = f(x^*)$。

这就找到了一个不动点 $x^*$。但这与我们最初的假设“$f(x) != x$ 对所有 $x in Delta^n$ 成立”相矛盾。
因此，最初的假设是错误的。

函数 $f$ 必须在 $Delta^n$ 中（因此在原始的非空紧致凸集 $X$ 中）至少有一个不动点。
证明完毕。

*第三步：构造一个连续函数 $f: Delta -> Delta$*

对于任意一个给定的混合策略组合 $sigma = (sigma_1, ..., sigma_n) in Delta$，我们来考虑参与者 $i$ 是否有动机改变其策略。

1.  *定义参与者 $i$ 从当前混合策略 $sigma_i$ 转向某个纯策略 $s_("ik") in S_i$ 的潜在“收益增益”*:
    对于每个参与者 $i in I$ 和其每个纯策略 $s_("ik") in S_i$ (其中 $k in {1, ..., m_i}$)，我们计算如果参与者 $i$ 单方面将其策略从 $sigma_i$ 变为纯策略 $s_("ik")$ (而其他参与者保持 $sigma_(-i)$ 不变)，其期望收益会是多少：
    $U_i (s_("ik"), sigma_(-i)) = sum_(s_(-i) in S_(-i)) ( product_(j != i) sigma_j(s_j) ) u_i (s_("ik"), s_(-i))$
    (这里 $S_(-i) = times_(j != i) S_j$)

    然后，我们定义参与者 $i$ 如果将其概率完全从当前混合策略 $sigma_i$ 切换到纯策略 $s_("ik")$ 所能获得的*额外收益*（gain）:
    $g_("ik") (sigma) = U_i (s_("ik"), sigma_(-i)) - U_i (sigma_i, sigma_(-i))$
    这个 $g_("ik") (sigma)$ 可以是正的（意味着切换到 $s_("ik")$ 更好）、负的（意味着切换到 $s_("ik")$ 更差）或零。

2.  *定义非负的“改进量”*:
    我们只关心那些能带来正收益的改变。所以，我们定义：
    $c_("ik") (sigma) = max{0, g_("ik") (sigma)} = max{0, U_i (s_("ik"), sigma_(-i)) - U_i (sigma_i, sigma_(-i))}$
    这个 $c_("ik") (sigma)$ 表示参与者 $i$ 通过将策略重心更多地移向纯策略 $s_("ik")$ (如果这能提高收益的话) 所能获得的非负“改进动力”。
    由于 $U_i$ 是连续的，$max$ 函数也是连续的，所以 $c_("ik") (sigma)$ 是关于 $sigma$ 的连续函数。

3.  *构造新的混合策略 $sigma_i'$*:
    基于这些“改进动力”，我们为每个参与者 $i$ 构造一个新的混合策略 $sigma_i' = (sigma_i'(s_("i1")), ..., sigma_i'(s_("im"_i)))$，其定义如下：
    对于每个纯策略 $s_("ik") in S_i$：
    $sigma_i'(s_("ik") | sigma) = (sigma_i(s_("ik")) + c_("ik")(sigma))/(1 + sum_(j=1)^(m_i) c_("ij")(sigma))$


4.  *定义函数 $f$*:
    我们现在可以定义函数 $f: Delta -> Delta$ 为：
    $f(sigma) = sigma' = (sigma_1'(times | sigma), sigma_2'(times | sigma), ..., sigma_n'(... | sigma))$
    其中每个 $sigma_i'(... | sigma)$ 都按照上面的方式构造。

    *函数 $f$ 的连续性*:
       我们已经知道 $U_i(sigma)$ 是连续的。
     $U_i(s_("ik"), sigma_(-i))$ 也是 $U_i$ 的一种形式，当 $sigma_i$ 是一个纯策略时，它也是关于 $sigma_(-i)$ 连续的，从而关于 $sigma$ 连续。
       $c_("ik")(sigma)$ 作为连续函数的组合（$max$ 和减法）也是连续的。
       分母 $1 + sum_(j=1)^(m_i) c_("ij")(sigma)$ 是连续的，并且由于 $c_("ij")(sigma) >= 0$，分母总是 $>= 1$，所以永远不会为零。
       因此，$sigma_i'(s_("ik") | sigma)$ 的每个分量都是 $sigma$ 的连续函数。
       所以，函数 $f(sigma) = sigma'$ 是一个从 $Delta$ 到 $Delta$ 的连续函数。


*第四步：应用布劳威尔不动点定理*

我们已经具备了应用布劳威尔不动点定理的所有条件：
1.  $Delta$ 是欧几里得空间中的一个非空、紧致、凸子集。
2.  $f: Delta -> Delta$ 是一个连续函数。

根据布劳威尔不动点定理，函数 $f$ 必然存在至少一个不动点。也就是说，存在一个混合策略组合 $sigma^* in Delta$ 使得 $f(sigma^*) = sigma^*$。


*第五步：证明不动点 $sigma^*$ 即为纳什均衡*

如果 $f(sigma^*) = sigma^*$，那么对于每个参与者 $i in I$ 和其每个纯策略 $s_("ik") in S_i$，我们有：
$sigma_i^*(s_("ik")) = sigma_i'(s_("ik") | sigma^*) = (sigma_i^*(s_("ik")) + c_("ik")(sigma^*)) / {1 + sum_(j=1)^(m_i) c_("ij")(sigma^*)}$

我们来分析这个等式：
$sigma_i^*(s_("ik")) ( 1 + sum_(j=1)^(m_i) c_("ij")(sigma^*) ) = sigma_i^*(s_("ik")) + c_("ik")(sigma^*)$
$sigma_i^*(s_("ik")) + sigma_i^*(s_("ik")) sum_(j=1)^(m_i) c_("ij")(sigma^*) = sigma_i^*(s_("ik")) + c_("ik")(sigma^*)$
$sigma_i^*(s_("ik")) sum_(j=1)^(m_i) c_("ij")(sigma^*) = c_("ik")(sigma^*)$

令 $K_i^* = sum_("j=1")^(m_i) c_("ij")(sigma^*)$。这是一个非负常数（对于给定的 $sigma^*$ 和参与者 $i$）。
则上式变为：
$sigma_i^*(s_("ik")) K_i^* = c_("ik")(sigma^*)$

回顾 $c_("ik")(sigma^*) = max{0, U_i (s_("ik"), sigma_(-i)^*) - U_i(sigma_i^*, sigma_(-i)^*)}$.

*核心论证：*
我们需要证明，在不动点 $sigma^*$ 处，对于所有参与者 $i$，必然有 $K_i^* = 0$。
如果 $K_i^* = 0$，那么对于所有的 $j in {1, ..., m_i}$，我们有 $c_("ij")(sigma^*) = 0$。
这意味着 $max{0, U_i (s_("ij"), sigma_(-i)^*) - U_i(sigma_i^*, sigma_(-i)^*)} = 0$。
所以 $U_i(s_("ij"), sigma_(-i)^*) - U_i(sigma_i^*, sigma_(-i)^*) <= 0$，即：
$U_i(s_("ij"), sigma_(-i)^*) <= U_i(sigma_i^*, sigma_{-i}^*)$ 对所有纯策略 $s_("ij") in S_i$ 成立。

如果这个条件成立，那么对于任意一个混合策略 $sigma_i in Delta_i$：
$U_i(sigma_i, sigma_(-i)^*) = sum_(j=1)^(m_i) sigma_i (s_("ij")) U_i(s_("ij"), sigma_(-i)^*)$
由于 $U_i(s_("ij"), sigma_(-i)^*) <= U_i(sigma_i^*, sigma_(-i)^*)$ 对所有 $j$ 成立，
$U_i(sigma_i, sigma_(-i)^*) <= sum_(j=1)^(m_i) sigma_i(s_("ij")) U_i(sigma_i^*, sigma_(-i)^*) = U_i(sigma_i^*, sigma_(-i)^*) sum_(j=1)^(m_i) sigma_i(s_("ij")) = U_i(sigma_i^*, sigma_("-i")^*) times 1$
所以 $U_i(sigma_i, sigma_(-i)^*) <= U_i(sigma_i^*, sigma_(-i)^*)$。
这正是纳什均衡的定义：没有任何参与者 $i$ 可以通过单方面改变其策略 $sigma_i$ 来获得比 $U_i(sigma_i^*, sigma_(-i)^*)$ 更高的收益。

*现在我们必须证明 $K_i^* = 0$。*
假设，为了寻求矛盾，存在某个参与者 $i$ 使得 $K_i^* > 0$。
这意味着至少存在一个纯策略 $s_("il") in S_i$ 使得 $c_("il")(sigma^*) > 0$。
如果 $c_("il")(sigma^*) > 0$，则 $U_i(s_("il"), sigma_{-i}^*) - U_i(sigma_i^*, sigma_(-i)^*) > 0$，即 $U_i(s_("il"), sigma_(-i)^*) > U_i(sigma_i^*, sigma_(-i)^*)$。

我们知道 $U_i(sigma_i^*, sigma_(-i)^*) = sum_(k=1)^(m_i) sigma_i^*(s_("ik")) U_i(s_("ik"), sigma_(-i)^*)$。
如果对于所有 $sigma_i^*(s_("ik")) > 0$ 的纯策略 $s_("ik")$ (即那些在 $sigma_i^*$ 中以正概率使用的策略)，都有 $U_i(s_("ik"), sigma_(-i)^*) > U_i(sigma_i^*, sigma_(-i)^*)$，那么它们的加权平均值 $U_i(sigma_i^*, sigma_(-i)^*)$ 也必须大于 $U_i(sigma_i^*, sigma_(-i)^*)$，这显然是矛盾的 ($X > X$ is false)。

更细致地看：
从 $sigma_i^*(s_("ik")) K_i^* = c_("ik")(sigma^*)$：
1.  如果 $sigma_i^*(s_("ik")) > 0$（即 $s_("ik")$ 是 $sigma_i^*$ 的支撑集中的一个策略）：
    那么 $K_i^* = c_("ik")(sigma^*) / sigma_i^*(s_("ik"))$。
    由于 $K_i^* > 0$ (我们的假设)，这意味着 $c_("ik")(sigma^*) > 0$。
    $c_("ik")(sigma^*) > 0 "implies" U_i(s_("ik"), sigma_(-i)^*) - U_i(sigma_i^*, sigma_(-i)^*) > 0 "implies" U_i(s_("ik"), sigma_(-i)^*) > U_i(sigma_i^*, sigma_(-i)^*)$。
    所以，所有在混合策略 $sigma_i^*$ 中以正概率使用的纯策略 $s_("ik")$，都必须产生严格大于 $U_i(sigma_i^*, sigma_(-i)^*)$ 的期望收益。

2.  如果 $sigma_i^*(s_("ik")) = 0$（即 $s_("ik")$ 不在 $sigma_i^*$ 的支撑集中）：
    那么 $0 times K_i^* = c_("ik")(sigma^*)$, 所以 $c_("ik")(sigma^*) = 0$。
    $c_("ik")(sigma^*) = 0 "implies" U_i(s_("ik"), sigma_(-i)^*) - U_i(sigma_i^*, sigma_(-i)^*) <= 0 "implies" U_i(s_("ik"), sigma_(-i)^*) <= U_i(sigma_i^*, sigma_(-i)^*)$。
    所以，所有在混合策略 $sigma_i^*$ 中以零概率使用的纯策略 $s_("ik")$，产生的期望收益不大于 $U_i(sigma_i^*, sigma_(-i)^*)$。

现在，将这两点结合起来考虑 $U_i(sigma_i^*, sigma_(-i)^*)$ 的构成：
$U_i(sigma_i^*, sigma_(-i)^*) = sum_(s_("ik") in S_i) sigma_i^*(s_("ik")) U_i(s_("ik"), sigma_(-i)^*)$
$= sum_(s_("ik") : sigma_i^*(s_("ik")) > 0) sigma_i^*(s_("ik")) U_i(s_("ik"), sigma_(-i)^*)$ (因为 $sigma_i^*(s_("ik"))=0$ 的项不贡献)

根据第1点，对于所有使 $sigma_i^*(s_("ik")) > 0$ 的 $s_("ik")$，我们有 $U_i(s_("ik"), sigma_(-i)^*) > U_i(sigma_i^*, sigma_(-i)^*)$。
那么， $U_i(sigma_i^*, sigma_(-i)^*)$ 是一个加权平均，其中所有的权重 $sigma_i^*(s_("ik"))$ 都是正的，并且每个被加权的值 $U_i(s_("ik"), sigma_(-i)^*)$ 都严格大于这个平均值本身。
例如，如果 $A = w_1 V_1 + w_2 V_2$ 且 $w_1, w_2 > 0, w_1+w_2=1$，并且 $V_1 > A$ 和 $V_2 > A$，这是不可能的。
所以，假设 $K_i^* > 0$ 导致了矛盾。

因此，对于所有参与者 $i in I$，必然有 $K_i^* = 0$。
如前所述，如果 $K_i^* = sum_(j=1)^(m_i) c_("ij")(sigma^*) = 0$，并且因为每个 $c_("ij")(sigma^*) >= 0$，所以必定有 $c_("ij")(sigma^*) = 0$ 对于所有 $j in {1, ..., m_i}$ 成立。
这意味着 $max{0, U_i(s_("ij"), sigma_(-i)^*) - U_i(sigma_i^*, sigma_(-i)^*)} = 0$ 对所有纯策略 $s_("ij")$ 成立。
因此，$U_i(s_("ij"), sigma_(-i)^*) <= U_i(sigma_i^*, sigma_(-i)^*)$ 对所有纯策略 $s_("ij") in S_i$ 成立。
这进一步意味着对于任何混合策略 $sigma_i in Delta_i$，$U_i(sigma_i, sigma_(-i)^*) <= U_i(sigma_i^*, sigma_(-i)^*)$。

由于这对所有参与者 $i in I$ 都成立，所以 $sigma^*$ 是一个纳什均衡。


*纯策略纳什均衡作为特例：*
如果一个混合策略纳什均衡 $sigma^*$ 恰好使得每个参与者 $i$ 的混合策略 $sigma_i^*$ 将全部概率 (即概率1) 分配给某个单一的纯策略 $s_i^("pure") in S_i$，那么这个纳什均衡实际上就是一个纯策略纳什均衡。也就是说，纯策略是混合策略的一种特殊形式，其中某个纯策略的概率为1，其他纯策略的概率为0。
