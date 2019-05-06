# Juliaの文法

Juliaの文法についてのメモ

### \<T> パラメトリック型
具体的な型を指定することなく,型のパラメータを指定したもの.

```julia
struct Point{T}
   x::T
   y::T
end
```

とすると,型を引数にとったものが作れる.
パラメトリック型に対しては、デフォルトのコンストラクタは1つしか生成されません。オーバーライドできないためです。
このコンストラクタは任意の引数を受け取り、フィールドの型に変換します。

また,コンストラクタの名前はstructと同じにする必要があります.

```julia
struct Point{T}
   x::T
   y::T
   function Point(x::T, y::T)
      return new{T}(x, y + 1))
   end
end
```

## Array
JuliaのArrayとVectorの関係も後でまとめる.

findfirst(function, array)
- arrayの要素の中でfunctionの返り値がtrueになる最初のindexを返却する.
- 見つからない場合は0となる.
