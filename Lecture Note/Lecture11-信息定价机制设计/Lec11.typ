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

= Lecture 11: The Valuation and Pricing of Information

== I.Economic Foundations of Value of Information

#figure(
  image("/images/image31.png", width: 80%),
) <fig:fig31>

Without information, decision maker(DM) gets $max_(a) [bb(E)_(omega ~ q) u(a,omega)]=t$

With my (full) information, DM gets $bb(E)_(omega ~ q) [max_(a) u(a,omega)] = 2 t$

Value of (full) info = $bb(E)_(omega ~ q) [max_a u(a,omega)] - max_a [bb(E)_(omega ~ q) u(a,omega)]$

#figure(
  image("/images/image32.png", width: 80%),
) <fig:fig32>

#figure(
  image("/images/image33.png", width: 80%),
) <fig:fig33>

Realistically, can think of 0 as noisy prediction of state $omega$ (e.g., stock trend, purchase prob)

*Question*: What is the value of this noisy signal 0?
- Without knowing this signal, DM takes action 1
- With this signal 0, DM takes action 0(assuming $epsilon$ very small)
- However, true distribution is the posterior $p$ regardless
$ "Value of knowing 0" = bb(E)_(omega ~ p) [u(0,omega)] - bb(E)_(omega ~ p) u(1,omega) $

*Definition(FK'19)*:Consider an arbitrary desicion making problem $u(a,omega)$, suppose a signal updates the DM's belief about state $omega$ from $q in Delta(Omega)$ to $p in Delta(Omega)$, the value of this signal is defined as 
$ D^u (p;q) = bb(E)_(omega ~ p) [u(a^ast (p),omega)] - bb(E)_(omega ~ p) u(a^ast (q), omega) $

Example 1:
- $a in A = Delta(Omega) ->$ action is to pick a distribution over states
- $u(a, omega) = log a_(omega)$
- Which action $a in Delta(Omega)$ maximizes expected utility $bb(E)_(omega ~ p) [u(a,omega)]$?
$ a^ast (p) = p $
$ D^u (p;q) = sum_(omega) p_(omega) log (p_omega)/(q_omega)"     KL-divergence" $

Example 2:
- $a in A = Delta(A) ->$ action is to pick a distribution over states
- $u(a, omega) = - ||a-e_omega||^2$
$ a^ast (p) = p $
$ D^u (p;q) = ||p-q||^2 "    Squared distance" $

*Some obvious properties*
- Non-negativity: $D^u (p;q) >= 0$
- Null information has no value: $D^u (q;q) = 0$
- Order-invariant: if DM receives signal $sigma_1, sigma_2$, the order of receiving them does not affect final expected total value

In this case, we say $D(p;q)$ is a valid measure for value of information

*Theorem 1(FK'19)*: Consider any $D(p;q)$ function. There exists a decision problem $u(a, omega)$ such that 
$ D^u (p;q) = bb(E)_(omega ~ p) [u(a^ast (p),omega)] - bb(E)_(omega ~ p) u(a^ast (q), omega) $
if and only if $D(p;q)$ satisfies
- Non-negativity: $D^u (p;q) >= 0$
- Null information has no value: $D^u (q;q) = 0$
- Order-invariant: if DM receives signal $sigma_1, sigma_2$, the order of receiving them does not affect final expected total value

*Theorem 2(FK'19)*: 
+ For any concave function $H$, its Bregman divergence is a valid measure for value of information.
+ Conversely, for any valid measure $D(p;q)$ for value of information,  $ H(q) = sum_(omega) q^(omega) D(e_(omega), q) $ is a concave function whosw Bregman divergence is $D(p;q)$

Why useful?
- Many functions - even natural ones like $l_2$ distance $||p-q||$- are not valid measures
- In fact, any metric is not valid, since metric cannot be a Bregman divergence
- There are efficient ways to tell whether a $D(p,q)$ is valid

== II.Optimal Pricing of Information

=== 1.Plans

- Vignette 1: closed-form optimal mechanism for structed setups
- Vignette 2: algorithmic solution for general setups
- Vignette 3: from distilled data (i.e. information) to raw data

=== 2.A Model of Information Pricing
- One seller, one buyer
- Buyers is a decision marker who faces a binary choice: an active action 1 and a passive action 0: Active action: come to talk, approve loan, invest stock X, etc.
- Payoff of passive action $equiv$ 0
- Payoff of active action$= v(omega, t)=v_1 (omega) [t + rho(omega)]$
   - $omega$ is a state of nature, $t$ is buyer type
   - Assume $v(omega,t)$ is linear and non-decreasing in $t in [t_1,t_2]$
- Information structure:
   - Seller observes $omega$, and buyer knows $t$

*Mechanism design question*: How can seller optimally sell her information about $omega$ to the buyer?

=== 3.Design Space

Standard revelation principle implies optimal mechanism can w.l.o.g be a menu ${pi_t, p_t}_(t in T)$
- $pi_t:Omega -> S$ is an experiment (which generates signals) for type $i$
- $p_t in bb(R)$ is $t$'s payment
- Each type is incentivized to report type truthfully

*Concrete design question*: design IC ${pi_t,p_t}_(t in T)$ to maximize seller's revenue

=== 4.How Does It Differ from Selling Goods?
- Each experiment is like an item
   - In this sense, we are selling infinitely many goods 
   - In fact, we are even "designing the goods"
- Participation constraint is different
   - Without any information, type $t$'s utility is $max {overline(v)(t), 0}$
$ overline(v)(t) = integral_(omega in Omega) v(omega, t) g(omega) d omega $
$ "Ex-ante expected utility of action 1" $

=== 5.Threshold experiments turn out to suffice
$ "Recall " v(omega,t) = v_1 (omega)[t + rho(omega)] $
*Def.* $pi_t$ is a threshold experiment if $pi_t$ simply reveals $rho(omega)>= theta(t)$ or not some buyer-type-dependent threshold $theta(t)$

Threshold is on $rho(omega)$

=== 6.Virtual Value Functions

Recall virtual value function in [Myerson'81]: $phi (t) = t - (1 - F(t))/(f(t))$

*Def.*
- Lower virtual value function: $phi(t) = t - (1 - F(t))/(f(t))$
- Upper virtual value function: $overline(phi)(t) = t + (F(t))/(f(t))$
- Mixed virtual value function: $phi_c (t) = c underline(phi)(t) + (1-c)overline(phi)(t)$

Note:"upper" or "lower" is due to:
$ underline(phi)(t) <= t <= overline(phi)(t) $

=== 7.The Optimal Mechanism

Depend on two problem-related constants:
$ V_L = max{v(t_1), 0} + integral_(t_1)^(t_2) integral_(q:rho(q)>= - underline(phi)^+ (x)) g(q) v_1 (q) d q d x $
$ V_H = max{v(t_1), 0} + integral_(t_1)^(t_2) integral_(q:rho(q)>= - overline(phi)^+ (x)) g(q) v_1 (q) d q d x $
Note:$ V_L < V_H $

*Theorem([LSX'21])*
+ If $overline(v)(t_2) <= V_L$, the mechanism with threshold experiments $theta^ast (t) = - underline(phi)(t)$ and following payment function represents an optimal mechanism:   $ p^ast (t) = integral_(omega in Omega) pi^ast (omega, t) g(omega) v(omega,t) d omega - integral_(t_1)^(t) integral_(omega in Omega) pi^ast (omega,x) g(omega) v_1 (omega) d omega d x $
+ If $overline(v)(t_2) >= V_H$, the mechanism wit threshold experiments $theta^ast (t) = - overline(phi)(t)$ and following payment function represents an optimal mechanism:   $ p^ast (t) = integral_(omega in Omega) pi^ast (omega,t) g(omega) v(omega, t) d omega + integral_(t)^(t_2) integral_(omega in Omega) pi^ast (omega, x) g(omega) v_1 (omega) d omega d x - overline(v)(t_2) $
+ If $V_L <= overline(v)(t_2)<= V_H$, the mechanism with threshold experiments $theta^ast (t) = - phi_c (t)$ and following payment function represents an optimal mechanism  $ p^ast (t) = integral_(omega in Omega) pi^ast (omega, t) g(omega) v(omega, t) d omega - integral_(t_1)^(t_2) integral_(omega in Omega) pi^ast (omega, x)g(omega) v_1 (omega) d omega d x $ where constant $c$ is chosen such that $ integral_(t_1)^(t_2) integral_(omega: rho(omega)>= phi_c^+ (x)) g(omega) v_1 (omega) d omega d x = overline(v)(t_2) $

=== 8.Remarks
- Threshold mechanisms are common in real life:House/car inspections, stock recommendations: information seller only need to reveal it “passed” or “deserves a buy” or not
- Optimal mechanism has personalized thresholds and payments, tailored to accommodate different level of risk each buyer type can take:Different from optimal pricing of physical goods

What if seller is restricted to sell the same information to every buyer (e.g., due to regulation)? How will revenue change?
- This is the optimal price (Merson reserve) in previous example
- Revenue can be arbitrarily worse
- $1/e$ - approximation of optimal revenue if the value of full information as a function of t has monotone hazard rate 

=== 9.Additional Properties of Optimal Mechanism



== III.Summary and Open Problems