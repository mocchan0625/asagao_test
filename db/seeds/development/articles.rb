0.upto(9) do |idx|
  Article.create(
    title: "練習試合の結果#{idx}" + (idx % 3 == 0 ? "☆" : ""),
（4-6行省略）
    member_only: (idx % 3 == 0)
  )
end
