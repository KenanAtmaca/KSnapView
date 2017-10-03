# KSnapView
iOS Social Media Story Image Loader 🤳

![alt tag](https://user-images.githubusercontent.com/16580898/31142698-bc93677e-a883-11e7-97ff-7a298665a406.png)

#### Use

```Swift
        snpView = KSnapView(to: self)
        snpView.duration = 4
        snpView.count = images.count
        snpView.delegate = self
        snpView.setup()
```

##### Use Delegate

```Swift
  extension mainVC: KSnapViewDelegate {
  
    func didChange(index: Int) {
       self.imgView.image = images[index]
    }
    
    func finished(flag: Bool) {
        if flag {
            // finished
        }
    }
}
```

##### Next & Remove

```Swift
       snpView.next()
       snpView.remove()
```


## License
Usage is provided under the [MIT License](http://http//opensource.org/licenses/mit-license.php). See LICENSE for the full details.
