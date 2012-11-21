TSEngine --- Yet Another TSEngine Based on Javascript.
---------------------------

origin 是在厂子做的探索型研究，效果不是很好，但是已经可以通过初步对比排版效果来对比不同元素对排版的影响。
目前已确认排版影响元素： MathJax&gt;Hyphen&gt;中英混排。

现决定在 v1 版本中完善横向排版。以及在将来在 v2 版本中完善纵向排版。


### Note

+ 之前为了保证文章各个字体下的完美横向排版，采用了 dom 动态测量，这个是相当相当消耗时间的过程。现打算把宽度常量化(只初始化的时候测量一次 enchar\_str)。\[Need To Fix\]\[Important\]

### Author XIAOMO(wxm4ever@gmail.com) Write On 2012/11/21
