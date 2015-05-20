##iOS NSNotification的使用

如果在一个类中想要执行另一个类中的方法可以使用通知
1.创建一个通知对象：使用notificationWithName:object: 或者 notificationWithName:object:userInfo:
    NSNotification* notification = [NSNotification notificationWithName:kImageNotificationLoadFailed(connection.imageURL)
                                                                 object:self
                                                               userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",connection.imageURL,@"imageURL",nil]];

这里需要注意的是，创建自己的通知并不是必须的。而是在创建自己的通知之前，采用NSNotificationCenter类的方法 postNotificationName:object: 和 postNotificationName:object:userInfo:更加便利的发出通知。这种情况，一般使用NSNotificationCenter的类方法defaultCenter就获得默认的通知对象，这样你就可以给该程序的默认通知中心发送通知了。注意：每一个程序都有一个自己的通知中心，即NSNotificationCenter对象。该对象采用单例设计模式，采用defaultCenter方法就可以获得唯一的NSNotificationCenter对象。

注意：NSNotification对象是不可变的，因为一旦创建，对象是不能更改的。

2.注册通知：addObserver:selector:name:object:

可以看到除了添加观察者之外，还有其接收到通知之后的执行方法入口，即selector的实参。因此为了进行防御式编程，最好先检查观察者是否定义了该方法。例如：添加观察者代码有

[[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(aWindowBecameMain:)
    name:NSWindowDidBecomeMainNotification object:nil];

这里保证了self定义了aWindowBecameMain:方法。而对于一个任意的观察者observer，不能保证其对应的selector有aWindowBecameMain:，可采用[observer respondsToSelector:@selector(aWindowBecameMain:)]] 进行检查。所以完整的添加观察者过程为：

if([observer respondsToSelector:@selector(aWindowBecameMain:)]) {
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(aWindowBecameMain:) name:NSWindowDidBecomeMainNotification object:nil];
    }

注意到addObserver:selector:name:object:不仅指定一个观察者，指定通知中心发送给观察者的消息，还有接收通知的名字，以及指定的对象。一般来说不需要指定name和object，但如果仅仅指定了一个object，观察者将收到该对象的所有通知。例如将上面的代码中name改为nil,那么观察者将接收到object对象的所有消息，但是确定不了接收这些消息的顺序。如果指指定一个通知名称，观察者将收到它每次发出的通知。例如，上面的代码中object为nil，那么客户对象（self）将收到任何对象发出NSWindowDidBecomeMainNotification通知。如果既没有指定指定object，也没有指定name，那么该观察者将收到所有对象的所有消息。

3.发送通知：postNotificationName:object:或者performSelectorOnMainThread:withObject:waitUntilDone:

例如程序可以实现将一个文本可以进行一系列的转换，例如对于一个实例、RTF格式转换成ASCII格式。而转换在一个类（如Converter类）的对象中得到处理，在诚寻执行过程中可以加入或者删除这种转换。而且当添加或者删除Converter操作时，你的程序可能需要通知其他的对象，但是这些Converter对象并不需要知道被通知对象是什么，能干什么。你只需要声明两个通知，"ConverterAdded" 和 "ConverterRemoved"，并且在某一事件发生时就发出这两个通知。

当一个用户安装或者删除一个Converter，它将发送下面的消息给通知中心：

[[NSNotificationCenter defaultCenter]
    postNotificationName:@"ConverterAdded" object:self];

或者是

[[NSNotificationCenter defaultCenter]
    postNotificationName:@"ConverterRemoved" object:self];

通知中心将会区分它们对象对这些通知感兴趣并且通知他们。如果除了关心观察者的通知名称和观察的对象，还关心其他之外的对象，那么就把之外的对象放在通知的可选字典中，或者用方法postNotificationName:object:userInfo:。

而采用performSelectorOnMainThread:withObject:waitUntilDone:则是直接调用NSNotification的方法postNotification，而postNotificationName和object参数可以放到withObject的实参中。例如：

[[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:YES];//注意这里的notification为自定义的一个通知对象，可定义为NSNotification* notification = [NSNotification notificationWithName:@"ConverterAdded"object:self];//那么它的作用与上面的一致

4.移除通知：removeObserver:和removeObserver:name:object:

其中，removeObserver:是删除通知中心保存的调度表一个观察者的所有入口，而removeObserver:name:object:是删除匹配了通知中心保存的调度表中观察者的一个入口。

这个比较简单，直接调用该方法就行。例如：

[[NSNotificationCenter defaultCenter] removeObserver:observer name:nil object:self];

注意参数notificationObserver为要删除的观察者，一定不能置为nil。

PS：这里简单说一下通知中心保存的调度表。通知中心的调度表是给一些观察者指定的一些通知集。一个通知集是通知中心发出的通知的子集。每个表的入口包含：

通知观察者（必须要的）、通知名称、通知的发送者。

下图表示通知集中指定的通知的调用表入口的四种类型：


下图表示四种观察者的调度表
![ss](http://my.csdn.net/uploads/201206/20/1340161575_7012.png)


最后，提醒一下观察者收到通知的顺序是没有定义的。同时通知发出和观察的对象有可能是一样的。通知中心同步转发通知给观察者，就是说 postNotification: 方法直到接收并处理完通知才返回值。要想异步的发送通知，可以使用NSNotificationQueue。在多线程编程中，通知一般是在一个发出通知的那个线程中转发，但也可能是不在同一个线程中转发通知。