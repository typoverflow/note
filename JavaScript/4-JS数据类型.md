# JS数据类型
+ JS中总共有七种原始数据类型
  + `string, number, bigint, boolean, symbol, null, undefined`
  + 原始类型的意义在于，当对象之间需要进行运算时可以统一转换为原始类型进行运算
  + 因此，JS的原始类型必须尽可能的简单轻量
+ Object对象不是原始数据类型，比原始类型更重，需要额外的成本来维护

## 被当作对象的原始类型
+ 有的时候我们希望原始数据类型也能有一些“方法”，为此JS为原始数据类型实现了Object Wrapper，它们为`String, Number, Boolean, Symbol`
+ 比如，如果我们想要把一个字符串转为大写`str.toUpperCase()`，在这个过程中实际发生的情况为
  + JS为`str`创建一个包含字符串字面值的特殊对象，类型为`String`
  + 调用这个特殊对象的方法，比如`toUpperCase`
  + 打印方法返回的字面量
  + 特殊对象被销毁，只剩下原始类型`str`
+ **一般来讲，在JS中你可以使用`new String()`的方法显式创建对象包装器。不过这么做在JS中是不推荐的，除了在类型转换和创建时使用对象包装器外，不要显式使用对象包装器。**

## 数字类型
+ `isFinite`和`isNaN`可以检测一个给定的number是不是无穷/NaN
  + `Infinity`和`-Infinity`是一个特殊的数字，比任何给定的数值都大/小
  + `NaN`代表一个error
  + 如果给定的是`NaN`，那么`isFinite`的返回结果仍然是`False`。因此`isFinite`可以被用于检测结果是否为常规数字

![](img/2021-04-20-19-12-40.png)
+ `parseInt`和`parseFloat`：提供了一种比`+`号转换更加宽松的从字符串中解析数字的方式
  + 它们会从给定字符串的第一个字符位置开始读取数字，直到遇到非预期的字符位置。此时会发生error，然后返回之前收集到的数字
  ```javascript
  alert( parseInt('100px') )    // 100
  alert( parseFloat('12.5em') ) // 12.5
  alert( parseInt('12.3') )     // 12
  alert( parseFloat('12.3.4') ) // 12.3
  ```

## 字符串
+ 补充一些之前的文章中没有涉及的关于JS的知识点
+ 反引号除了允许嵌入`${}`字符之外，还允许字符串跨行
  ```javascript
  let guestList = `Guests:
  * John
  * Pete
  * Mary
  `; 
  ```
+ 特殊字符  
![](img/2021-04-21-23-37-20.png)
+ 字符串的方法和属性
  + `str.length`
  + `str.toLowerCase()/toUpperCase()`
  + `str[idx]`
  + `str.indexOf(substr, pos)`: 从给定的pos位置开始查找`substr`，没有找到返回`-1`，否则返回匹配成功的位置
    + 利用按位取反运算可以快速对子串匹配进行检测，因为只有`-1`的按位反是`0`
  + `str.lastIndexOf(substr, pos)`: 从字符串的末尾搜索到开头
  + `str.includes(substr, pos)`: 检测从`pos`位置开始的子串中是否包含`substr`，返回布尔值
  + `str.startsWith()`
  + `str.endsWith()`
  + `str.slice(start [, end])`: 获取切片，左闭右开
  + `str.substr(start [, length])`: 返回字符串从`start`开始的长度为`length`的那部分
  + `str.trims()`: 删除字符串前后空格

## 数组
+ 创建数组
```javascript
let arr = Array();
let arr = []; 
let arr = ['Apple', 'Orange', 'Plum']; 
```
  + 如果使用一个数字参数来创建数组，例如`new Array(2)`，则会创建一个长度为2，元素为`[undefined, undefined]`的数组
+ 索引元素
```javascript
alert(arr[2]); 
```
+ 方法和属性
  + `arr.length`: 获取数组长度
  + `arr.shift()`: 将`arr`视作队列，从队列开头取出元素
  + `arr.unshift()`: 在`arr`的开头位置插入元素
  + `arr.push()`: 将`arr`视作队列/栈，从队列/栈末尾加入元素
  + `arr.pop()`: 将`arr`视作栈，从栈末尾弹出元素6
  + `arr.splice(start [, deleteCount, elem1, elem2, ...])`: 可以完成数组元素的删除和添加操作
  + `arr.slice([start], [end])`: 返回数组从`start`到`end`的索引 
+ 要注意数组也是一种对象，支持添加新的属性
  ```javascript
  arr.age = 25
  ```
+ 遍历数组可以使用`for`循环
  ```javascript
  let fruits = ["Apple", "Orange", "Plum"]
  for (let fruit of fruits) {
    alert( fruit ); 
  }
  ```
  + 注意，`for in`语法会遍历一个对象的所有属性，如果对数组使用`for in`，则会遍历到很多例如`length`等不需要的属性

## 数组的其他方法
+ `arr.concat(arg1, arg2, ...)`: 将参数中的对象和arr拼接在一起形成新的数组返回。如果参数中的对象的`Symbol.isConcatSpreadable`属性为`true`，则该对象就会被当作数组进行处理。
  ```javascript
  ler arr = [1,2]; 
  let obj = {
    0: "Something", 
    1: "Else", 
    [Symbol.isConcatSpreadable]: true, 
    length: 3
  };
  console.log(arr.concat(obj))
  ```
+ `arr.forEach(function)`: 为数组的每一个元素都运行一个函数。默认情况下，`forEach`会向后面的函数最多传递三个参数`item, index, array`。该函数的结果会被抛弃和忽略
  ```javascript
  ["Bilbo", "Gandalf", "Nazgul"].forEach(
    (a) => console.log(a)
  )

  ["Bilbo", "Gandalf", "Nazgul"].forEach(
    (a, b, c) => console.log(`${a} is at index ${b} in ${c}.`)
  )
  ```
+ `arr.indexOf(item, from)`: 从from向右搜索item，返回第一个匹配的索引。若无匹配则返回-1
  + `arr.lastIndexOf(item, from)`: 逆序搜索
  + `arr.includes(item)`: 若找到则返回true
+ 根据条件筛选数组元素
  + `arr.find(function(item, index, array))`: 对每个元素作用这个函数，如果函数`function`返回true则最后返回这个元素并终止迭代，如果没有元素为true则最终返回undefined
  + `arr.findIndex(function(item, index, array))`: 返回找到的元素索引，未找到时返回-1
  + `arr.filter(function(item, index, array))`: 将数组中所有满足条件（function返回true）的元素筛选出来形成数组
+ `arr.map(function(item, index, array))`: 对每个 元素调用函数，返回新值
+ `arr.reduce(function(accumulator, item, index, array))`和`arr.reduceRight(function(accumulator, item, index, array))`: 略，一个是从左侧开始reduce，一个是从右侧开始reduce
+ `arr.sort(function(a, b))`: sort方法会对数组元素进行排序，但是在默认情况下`sort`会将数组内元素尝试转换为字符串后再根据字符串的规则进行排序，因此最好指定一个比较函数。函数返回正数应当表示大于，返回负数表示小于。**排序是in-place的。**
  ```javascript
  let arr = [1,2,15]; 
  arr.sort((a, b) => a-b); 
  ```
  + `arr.reverse()`: 颠倒数组中的顺序，in-place。
+ `Array.isArray(obj)`: 判断对象`obj`是否为数组类型
+ `split`和`join`方法
  + `str.split(sep)`: 使用`sep`将字符串分割为数组，如果`sep`未指定则将把字符串按照字符进行分割
  + `arr.join(sep)`: 使用`sep`连接数组中的元素形成字符串，如果`sep`未指定将会使用`,`作为连接符
+ **几乎所有调用函数的数组方法，比如`find, filter, map`等，都接受一个可选的附加参数`thisArg`。**在传入的函数`func`中，总是可以使用`this`来获取`arr`对象本身的属性和方法，而`thisArg`将指定具体使用哪个对象，默认/缺省情况下为`arr`本身。
  ```javascript
  let army = {
    minAge: 18, 
    maxAge: 27, 
    canJoin(user) {
      return user.age >= this.minAge && user.age < this.maxAge; 
    }
  };

  let users = [
    {age: 16}, 
    {age: 20}, 
    {age: 23}, 
    {age: 30}, 
  ];

  let soldiers = users.filter(army.canJoin, army); 
  ```
  调用外部对象的方法，需要为`thisArg`传入所调用的对象`this`

## 可迭代对象 Iterable Object
+ 数组的`for ... of ... `方法实际上依赖于数组对象的`Symbol.iterator`方法，该方法会创建一个该对象的迭代器并返回。
+ **迭代器（iterator）**是一个具有**next**方法的对象，`next()`方法返回的结果的格式必须是`{done: Boolean, value: any}`，当`done=true`时，表示迭代结束，否则`value`必须是下一个值
```javascript
let range = {
  from: 1, 
  to: 5  
}; 

range[Symbol.iterator] = function() {
  return {
    current: this.from, 
    last: this.to, 
    next() {
      if (this.current <= this.last) {
        return {done: false, value: this.current++ };
      } else {
        return {done: true}
      }
    }
  };
};

for (let num of range) {
  alert(num);
}
// 1,2,3,4,5
```
  + 也可以不创建额外的对象，直接使用range本身进行迭代
  ```javascript
  let range = {
    from: 1, 
    to: 5, 
    [Symbol.Iterator]() {
      this.current = this.from;
      return this;
    }, 
    next() {
      if (this.current <= this.to) {
        return {
          done: false, 
          value: this.current++
        };
      } else {
        return {
          done: true
        };
      }
    }
  };
  ```
+ 可迭代对象有：
  + 数组、字符串
+ 区分iterable和array-like object和数组
  + iterable: 实现了`Symbol.iterator`方法的对象
  + array-like: 是有索引和`length`属性的对象
  + 数组既是`iterable`也是`array-like`的，而对于`iterable`或`array-like`对象，可以使用`Array.from`方法创建一个新的数组，此时这个新创建的对象就有了类似数组一样的属性和方法
    + `Array.from(obj [, mapFn, thisArg])`的第二个函数`mapFn`指定了类数组/可迭代对象中的元素被添加到数组前需要作用的映射。

## 映射Map
+ Map创建与设置
  + `new Map()`: 创建哈希表
  + `map.set(key, value)`: 创建键值对
  + `map.get(key)`: 根据键返回值，如果不存在相应的`key`返回`undefined`
  + `map.has(key)`: 如果`key`存在则返回true，否则返回false
  + `map.delete(key)`: 删除指定键的值
  + `map.clear()`: 清空map
  + `map.size`: 返回当前哈希表中元素的个数
+ 与对象的不同之处
  + 对象的键全部会被隐式转换为字符串，而Map不会。Map甚至可以使用对象作为键。
+ Map迭代
  + `map.keys()`: 遍历并返回所有的键
  + `map.values()`: 遍历并返回左右的值
  + `map.entries()`: 遍历并以数组方式返回所有的实体`[key, value]`
  + `map.forEach(function(key, value, map))`: 使用forEach可以为`map`中的每一个键值对都运行一个函数。注意`forEach`最多会向函数传入三个参数，即键、值和map本身
+ `Object`和`Map`的相互转换
  + `new Map()`可以接受一个二维数组，并根据二维数组创建一个Map
  + `Object.entries(obj)`将对象`obj`中的所有键值对抽出形成一个二维数组，进而使用`new Map(Object.entries(obj))`可以创建一个新的Map
  + `Object.fromEntries(map)`将`map`中的所有键值对抽出形成对象

## 集合Set
Set可以被看作是键的集合
+ `new Set(iterable)`: 创建Set
+ `set.add(value)`: 添加一个值
+ `set.delete(value)`: 从集合中删除一个值
+ `set.clear()`: 清空集合
+ `set.size`: 返回集合中元素的个数

Set对象也可以进行迭代
+ `set.forEach(function(item, itemAgain, set))`: 使用forEach可以对set进行迭代并作用一个自定义函数，set会为这个函数最多传入三个值，即一个set中的元素，然后是同一个值，最后是set对象本身
+ `set.keys()/set.values()`: 返回set中所有存放的键
+ `set.entries()`: 遍历并以数组 形式返回所有实体`[key, key]`，这么做是为了兼容`map`的API


## 弱映射WeakMap和弱集合WeakSet
+ 在集合、映射和列表中，如果存放了一个对象，即使后来将这个设置为`null`，该对象指向的内存实体也不会被回收，因为容器仍保有一份指向该实体的引用
  ```javascript
  let john = {
    name:'John'
  };
  let set = new Set();
  set.add(john);
  john = null; 

  console.log(set); //Set(1) { { name: 'John' } }
  ```
+ 但是`WeakMap`与它们有明显的不同
  + `WeakMap`的键必须是对象，不能Primitive Type
  + **如果在WeakMap中使用一个对象作为键，并且没有其他对这个对象的引用，则该对象将会被从内存和WeakMap中自动清除**
  + 由于垃圾清理的延迟机制，`WeakMap`不支持**任何迭代方法**，仅有如下方法和属性
    + `weakMap.get(key)`
    + `weakMap.set(key, value)`
    + `weakMap.delete(ley)`
    + `weakMap.has(key)`
  + 往往在记录客户端访问状态和缓存时使用
  ```javascript
  // cache.js
  let cache = new WeakMap(); 
  function process(obj) {
    if (!cache.has(obj)) {
      let result = /*calculate the result for*/ obj;
      cache.set(obj, result);
    }

    return cache.get(obj);
  };

  let obj = /*some object*/;
  
  let res1 = process(obj); 
  let res2 = process(obj); 

  obj = null; 
  // 此时WeakMap中的obj缓存数据也会被清除
  ```
+ `WeakSet`与`WeakMap`相似，没有任何用于迭代的方法和`length`属性，仅有
  + `weakSet.has()  weakSet.add()  weakSet.delete()`方法

## Object类的方法
+ `Object.keys(obj)`: 返回s一个包含对象`obj`的所有键的**数组**
+ `Object.values(obj)`: 返回一个包含对象`obj`的所有值的数组
+ `Object.entries(obj)`: 返回一个包含该对象所有`[key, value]`键值对的所有数组
  + `Object.fromEntries(entries)`可以重新从数组构造对象
+ 和`map.keys() map.values() map.entries()`的不同之处
  + `map`的方法返回的对象均为iterator，而上面的方法均返回真正的数组

## 解构赋值
### 数组解构
+ JavaScript中支持对数组变量进行解构赋值
  + 等号右侧可以是任何可迭代对象
  + 左侧使用`[]`语法，可以是任何可以被赋值的对象，并且 可以使用空格丢弃对象的赋值
  ```javascript
  let [a, b, c] = "abc"; 
  let [a,  , c] = ["a", "b", "c"]
  let user = {
    name: "John", 
    age: 30
  };

  for (let [key, value] of Object.entries(user)) {
    alert(`key is ${key} and value is ${value}`);
  }
  ```
  + 收集多余元素
    + `let [name1, name2, ...rest] = ['Julius', 'Caesar', 'Consul', 'of the Roman Replublic']`
  + 默认值
    + 如果不提供默认值，当提供的用于解包的对象数量大于右侧元素数量时，多余的对象会被设置为`undefined`
    + 如果想要设置一个默认值给变量，可以在数组中使用`=`来提供：`let [name="Guest", surname="Anonymous"] = ["Julius"]`

### 对象解构
+ 解构赋值同样适用于对象，即等号右侧为一个对象，等号左侧为一系列与对象的键同名的变量。**对象解构会把对象的属性释放具有相同名字的变量中，因此等号左侧变量的名字很重要，而顺序并不重要。**
  ```javascript
  let {var1, var2} = {var1: ..., var2: ...}; 
  let options = {
    title: "Menu", 
    width: 100, 
    height: 200, 
  }; 
  let {title, width, height} = options;
  ```
+ 对象解构同样支持省略赋值，剩余属性被存储为对象
  ```javascript
  let {title, ...rest} = options
  console.log(rest)
  ```

### 嵌套赋值
+ 可以对对象/数组进行嵌套赋值
  ```javascript
  let options = {
    size: {
      width: 100, 
      height: 200
    }, 
    items: ["Cake", "Donut"], 
    extra: true
  };

  let {
    size: {
      width, 
      height, 
    }, 
    items: [item1, item2], 
    title = "Menu"
  } = options
  ```

### 智能函数参数
把所有对象当作参数来传递，需要函数在定义时把对象解构成多个变量
```javascript
let options = {
  title: "My Menu", 
  items: ["Item1", "Item2"]
};

function showMenu ({
  title = "Untitled", 
  width = 200, 
  height = 100, 
  items = []
}) {
  console.log(`${title} ${width} ${height}`);
  console.log(items);
}

showMenu(options)
```


## 日期和时间
### Date对象
+ `let date = new Data(); console.log(date)`: 创建Date对象，不会实时更新
  + `new Date(milliseconds)`: 创建新的Date对象，时间为距离Epoch的**毫秒数**
  + `new Date(datestring)`: 根据给定的日期字符串自动解析
  + `new Date(year, month, date, hours, minutes, seconds, ms)`: 其中year必须是四位数，否则JS会进行一些可能的调整
+ `date.getTime()`: 获取时间戳
+ 获取日期组件
  + `date.getFullYear()`
  + `date.getMonth()`
  + `date.getDate()`: 获取具体的“日”，从1到31
  + `date.getHours() date.Minutes() date.getMilliseconds()`
+ 设置日期组件
  + 将上面所有的`get`方法换成`set`即可
+ `Date`的自动校准 
  + Date对象在被设置不合理的值时，可以自动校准为合理的值。比如一个二月份的Date对象被设置为30日时，最终的结果可能被校准为3月1日或3月2日

### Date类方法
+ `Date`对象参与运算时，或隐式调用`date.getTime()`方法转化为时间戳进行运算。
+ `Date.now()`: 返回当前时间的时间戳
+ `Date.parse(string)`: 从一个字符串中解析时间，并返回**时间戳**
  + 字符串的格式形如`YYYY-MM-DDTHH:mm:ss.sssZ`
    + `YYYY-MM-DD`: 年月日
    + `T`是一个分隔符
    + `HH:mm:ss.sss`: 小时，分钟，秒，毫秒
    + `Z`为`+-hh:mm`格式的时区，单个字符`Z`表示UTC+0的时区

## JSON类
+ `JSON.stringify(obj)`可以将一个对象stringify成json文本
  + 其中一些JS特有的类型，比如函数方法、`Symbol`和存储`undefined`的属性就会被`JSON.stringify`忽略。
  + 如果存在对象作为值，会进行嵌套解析
  + `JSON.stringify(obj, replacer, spacers)`: 中的第二个参数可以是一个包含键值的数组或者是一个函数
    ```javascript
    let rooms = {
      number = 23, 
    }; 
    let meetup = {
      title: "COnference", 
      participants: [{name: "John"}, {name: "Alice"}], 
      place: room
    };
    room.occupiedBy = meetup; 

    console.log(JSON.stringify(meetup, ['title', 'participants']));
    // {"title":"COnference", "participants":[{}, {}]}
    ```
    在上面的例子中，`JSON.stringifty`只会编码`title`和`participants`属性。
    或者也可以使用一个函数，接受`key, value`两个参数，即整个对象在`stringify`时遇到的所有要编码的键， value为对应的值在`toString`后的结果字符串，该函数的返回值可以为`undefined`，如果返回`undefined`则将会被忽略。
  + `JSON.stringify(obj, replacer, space)`的第三个参数`space`用来控制返回的json对象的美观程度
+ 自定义的`JSON.stringify`行为
  + 只要为对象实现`obj.toJSON()`方法，之后`JSON.stringify`在JSON化这个对象时就会调用自定义的方法
+ `JSON.parse`: 将JSON字符串重新反序列化为对象
  + `JSON.parse(str [, reviver])`第二个参数`reviver`用于对反序列化时遇到的每一个键值对进行格外的操作
    ```javascript
    let str = '{"title":"Conference","date":"2017-11-30T12:00:00.000Z"}';

    let meetup = JSON.parse(str, function(key, value) {
      if (key == 'date') return new Date(value);
      return value;
    });

    console.log( meetup.date.getDate() )
    ```
    


