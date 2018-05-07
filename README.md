# NSArrayPropertyDemo
测试NSArray、NSMutableArray类型的属性使用copy、strong关键字，并使用NSArray、NSMutableArray类型的对象（copy、mutableCopy）给属性赋值，对属性的影响

## 得出的结论：
1. 不可变数组NSArray属性要使用**copy**关键字  
3. 可变数组NSMutableArray属性使用**strong**关键字

原因：
1. 不可变数组NSArray属性如果使用**strong**关键字，并赋值了一个可变数组对象，该属性也会指向这个可变数组。如果这个可变数组值发生改变，此属性的值也会改变（两个对象指向的是一个地址）。   
2. 如果可变数组NSMutableArray属性使用了**copy**关键字，则给这个属性赋值时不管是赋值可变数组还是不可变数组，得到的结果属性都会变成不可变数组。因为其实该属性的setter方法中真正赋值给属性实例变量的是[赋值对象 copy]，而copy返回的是不可变对象。所以，赋值之后，可变数组NSMutableArray属性会变成不可变对象，当调用数组的增删改查方法时会导致**崩溃**。
