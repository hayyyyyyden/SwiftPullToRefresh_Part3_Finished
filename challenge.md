挑战：如何添加动画？
===
当刷新视图锁定的那几秒钟的时间内，用户不知道发生了什么。所以我们要添加一些动画来给用户一些提示。

我们让地面和建筑向下移出屏幕，这样看起来猫就在天上飞，同时它的斗篷还在随风飘动！

当刷新动作开始的时候我们来激活这个动画，所以将下面这些代码加到`beginRefreshing()`这个函数的最后面：

```
// 猫和斗篷的动画
let cape = refreshItems[5].view
let cat = refreshItems[4].view
cape.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI/32)) 
cat.transform = CGAffineTransformMakeTranslation(1.0, 0) 
UIView.animateWithDuration(0.2, delay: 0,options: .Repeat | .Autoreverse, 
animations: { () -> Void in 
  cape.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/32)) 
  cat.transform = CGAffineTransformMakeTranslation(-1.0, 0)
}, completion: nil)

// 地面和建筑的动画
let buildings = refreshItems[0].view
let ground = refreshItems[2].view 
UIView.animateWithDuration(0.2, delay: 0,options: .CurveEaseInOut, 
animations: { () -> Void in 
  ground.center.y += sceneHeight
  buildings.center.y += sceneHeight
}, completion: nil)
```

对于猫和斗篷，这里的动画设置为不断重复(`repeat`)反转(`autoreverse`)，这样猫就不停的从一边移动到另一边，来回反复，让人感觉它真的飞在天上。

对于地面和建筑，这里的动画只会改变它的y坐标，让它移除屏幕。

当刷新完成的时候，你需要把猫和斗篷的循环动画停止。在`endRefreshing()`这个方法的最后加上下面这些代码：

```
let cape = refreshItems[5].view
let cat = refreshItems[4].view 
cape.transform = CGAffineTransformIdentity 
cat.transform = CGAffineTransformIdentity
cape.layer.removeAllAnimations()
```

这些代码将会把所有的图像回复到原始状态，以保证下次用户再下拉的时候效果不变。

编辑并运行，来看看这个会飞的超人猫吧！

隐藏挑战：添加云朵
===
恭喜你，走到了这一步！你已经打败了99%的地球人，地球上已经没有人了...（笑）

我们已经在图片库里面添加了几个云朵的图片：could_1，cloud_2 和 cloud_3，你的任务就是把这几个云朵添加到刷新视图里，并随着超人猫的向上飞，这些云朵不断地掉落。

你可以选择一个个地把这些图片添加到刷新视图里，你也可以制作一个透明的`UIView`作为容器，跟刷新视图一样大，让后把这些云朵作为子视图加入这个容器中，这样会更容易些。

不断掉落的效果很容易实现，当这些云朵向下移出屏幕后，你再把它们移动到屏幕的上方就可以了。

好了，不多说了，接下来看你的了！如果过程中遇到困难，可以参考我们给出的最终代码。从代码中学习也是一种必须的能力！加油！
