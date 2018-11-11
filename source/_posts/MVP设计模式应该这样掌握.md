---
title: MVP设计模式应该这样掌握
date: 2017-11-06 19:53:51
tags: 
- Android 
- MVP 
- 设计模式
categories: 
- Android
---
> 前言：在学习MVP设计模式时，我们所读的大部分文章都是首先介绍什么是MVP以及MVP与MVC设计模式的不同，这些文章都讲的很好，但是这些理论的东西不但容易忘记，可能对于那些都没有接触过MVC设计模式的人来说还有点难以理解。这篇文章理论知识很少，重点是让你能将MVP设计模式用到自己的开发中。

<!-- more -->

<font color="red" size = "4">注： </font>阅读本文一定要自己动手写代码！自己敲一遍代码感受一下MVP设计模式。

# MVP的简单介绍

&emsp;&emsp;还是要讲点理论！MVP分别是**Mode**、**View**和**Presenter**，翻译过来就是**数据**、**视图**和**主持者**，行！就先知道这么多，下面动手写代码。

# MVP设计模式初体验

&emsp;&emsp;这里用一个List来代表**数据层**，Activity就是**视图层**，AddPresenter来作为**主持者**，下面编写代码。

## 设计数据层

&emsp;&emsp;首先定义一个名为StudentDataSource的接口，为了能更容易的理解MVP设计模式，这里就只有一个添加数据的方法，如下

```java
public interface StudentDataSource {
    void addStudent(Student student);
}
```

&emsp;&emsp;接着写一个名为StudentRepository的类实现StudentDataSource接口，如下

```java
public class StudentRepository implements StudentDataSource{
    private List<Student> mStudents = new ArrayList<>();
    @Override
    public void addStudent(Student student) {
        mStudents.add(student);
    }
}
```

行，这样就写好了数据层即Mode，简单吧！下面就分别来实现**视图层**和**主持者**。

## 设计视图层和主持者

&emsp;&emsp;同样，先写一个BasePresenter接口和BaseView接口分别作为主持者和视图层的基类，如下

```java
public interface BasePresenter {
}
```

```java
public interface BaseView<T> {
    void setPresenter(T presenter);
}
```

下面将视图层和主持者层都放进一个AddStudentContract契约类里，如下

```java
public interface AddStudentContract {
    interface Presenter extends BasePresenter {
        void saveStudent();

    }

    interface View extends BaseView<Presenter> {
        void showSaveSuccess();
    }

}

```

这样做的好处是可以统一管理View层和Presenter层，这样就将接口设计好了，先面开始写实现类。先看Presenter层的实现类AddStudentPresenter,如下

```java
public class AddStudentPresenter implements AddStudentContract.Presenter {
    private AddStudentContract.View mAddStudentView;
    private StudentDataSource addStudentRepository;

    public AddStudentPresenter(AddStudentContract.View view) {
        mAddStudentView = view;
        addStudentRepository = new StudentRepository();
    }

    @Override
    public void saveStudent() {
        Student student = new Student();
        student.setAge(20);
        student.setName("wizardev");
        addStudentRepository.addStudent(student);
        mAddStudentView.showSaveSuccess();
    }
}
```

再看View层的实现，这里View层的实现就是Activity，代码如下

```java
public class AddStudentActivity extends AppCompatActivity implements AddStudentContract.View {
    private AddStudentContract.Presenter mPresenter;
    private Button mAddStudent;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mPresenter = new AddStudentPresenter(this);
        setPresenter(mPresenter);
        mAddStudent = findViewById(R.id.addStudent);
        mAddStudent.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPresenter.saveStudent();
            }
        });
    }

    @Override
    public void setPresenter(AddStudentContract.Presenter presenter) {
        if (presenter != null) {
            mPresenter = presenter;
        }
    }

    @Override
    public void showSaveSuccess() {
        Toast.makeText(this,"添加成功！",Toast.LENGTH_SHORT).show();
    }
}
```

好了，上面即使MVP的设计模式的使用，到了这里先停下来，先自己把上面的代码写一遍，体会一下，然后再继续阅读。

# MVP设计模式的总结

&emsp;&emsp;通过自己动手编写代码，相信你已经对MVP设计模式有了一定的了解，下面看下MVP设计模式的结构图

![图示MVP设计模式](http://ot6991tvl.bkt.clouddn.com/mvp.jpg)

通过这幅图和我们自己写的代码，我们会发现Presenter层是Mode层和View层通讯的桥梁，同时也将View层和Mode层隔离开来，使它们不能直接的进行通讯，同过这种方法达到了解耦合的目的。

&emsp;&emsp;通过编写代码，会发现AddStudentPresenter同时持有Mode层和View层的引用，这样就能在需要数据改变或视图显示时直接改变数据或者视图的显示状态。同样View层持有Presenter层的引用，这样就能将一些处理事件的逻辑放在Presenter层中进行处理，处理完成后通知View层改变显示状态。

&emsp;&emsp;Mode层呢，Mode层不止是实体类还有数据的增删改查，Mode层只做与数据相关的操作。

&emsp;&emsp;虽然MVP设计模式使代码增加不少，包结构也变得复杂，但是他使数据和视图高度解偶，让代码变的更加清晰，更易于维护，同时也方便对各个模块进行单独的测试。

# 结束语

&emsp;&emsp;文章采用先动手写代码后理论的模式，是为了能让大家更好的理解MVP设计模式，可以直接在项目中进行使用，缩短掌握MVP设计模式所需的时间。文章中的代码在[这里](https://github.com/funaihui/MVPPottern)

> <font color=#d2691e size = 5>转载请注明出处：[www.wizardev.com](http://www.wizardev.com)<font>
