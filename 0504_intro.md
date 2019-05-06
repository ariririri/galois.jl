# Juliaで代数的数を作る

最近計算機代数に興味があります.
そこで代数の王道だと思いますが多項式の最小分解体を求め,そのガロア群を求めることを目指し,Juliaで実装していきたいと思います.

すでに
- [週刊 代数的実数を作る](https://miz-ar.info/math/algebraic-real/)
- [五次元世界の冒険](http://ikumi.que.jp/blog/archives/252)
- [Swiftで代数学入門 ](https://qiita.com/taketo1024/items/bd356c59dc0559ee9a0b)

等様々な素晴らしいサイトがありますが,Juliaの理解を含め勉強していこうと思います.

代数拡大をするには多項式環を既約多項式で割った体を考える必要があるので,
しばらくは一変数多項式を定義して,いろいろ実装しようと思います.

今回は最初なので,

- [x] 多項式の定義
- [x] 次数
- [x] 和,差,積,定数倍
- [x] 割り算(商,余り)
- [x[ GCD
- [x] 微分
- [x] 値の代入
- [x] 合成
- [x] squarefree
- [x] monic

等をまとめようと思います.

一変数多項式は一変数の配列で定義できます.
変数も設定しておきたいので,それも設定しておきます.

特に多項式はただの配列と思わない演算を定義するので型として定義しました.

```julia
struct Poly{T<:Number}
  a::Vector{T}
  var::Symbol
  # constructor
  function Poly(a::AbstractVector{T}, var::Symbol = :x)
    #  a == [] -> a = [0]
    if length(a) == 0
      new{T}(zeros(T,1), var)
    else
      new{T}(a, var)
    end
  end
end
```

定数も多項式と思う場合は配列にしなくてもできるようにします.

```julia
Poly(n::Number, var::Symbol=:x) = Poly([n], var)
```


## 多項式の既約分解
有理数係数の多項式既約な多項式の積に分解します.
方法はいろいろあります.

- Kroneckerの方法
  一番シンプルなものです.もし整数係数多項式$f$が$g$を約数に持っているなら任意の整数$k$に対し.$g(k) | f(k)$となるので,それから$g$として取りうるものを虱潰しに計算する求めて.計算します.
- Cantor-Zassenhausの方法(有限体の場合)
- Berlekampの方法(有限体の場合)
- 大きい素数を使う方法
  大きい素数を使って有限体の場合に帰着させる話
- Henselの補題を使う方法

## 代数的数の実現
多項式とその多項式が解を持つ範囲によって多項式を実現する.
