title: 使用MyBatis轻松实现递归查询与存储过程调用
date: 2018-01-23 14:03:31
tags: [Mybatis]
categories: [Mybatis]
---
### 递归调用
由于部门的层级不可控，因此如果我想要获取所有部门的完整json的话，就要采用递归调用，使用Java代码处理递归有点low，刚好MyBatis的ResultMap中的collection可以很方便的解决这个问题，核心代码如下：

```
<resultMap id="BaseResultMap" type="org.sang.bean.Department">
    <id property="id" column="id"/>
    <result column="name" property="name"/>
    <result column="parentId" property="parentId"/>
    <result column="isParent" property="isParent"/>
    <collection property="children" ofType="org.sang.bean.Department" select="org.sang.mapper.DepartmentMapper.getDepByPid" column="id">
    </collection>
</resultMap>
<select id="getDepByPid" resultMap="BaseResultMap">
    select d1.*from department d1 where d1.`parentId`=#{pid} AND d1.enabled=true;
</select>
```
<!--more-->

每一个Department中都有一个children属性，getDepByPid方法的返回结果是一个BaseResultMap，BaseResultMap中的collection又将调用getDepByPid方法，通过这种方式我们可以快速实现一个递归调用。Mapper中只需要定义如下方法即可：

```
List<Department> getDepByPid(Long pid);
```

查询结果如下(部分)：

```
[
    {
        "id": 1,
        "name": "股东会",
        "parentId": -1,
        "enabled": true,
        "children": [
            {
                "id": 4,
                "name": "董事长",
                "parentId": 1,
                "enabled": true,
                "children": [
                    {
                        "id": 5,
                        "name": "总经理",
                        "parentId": 4,
                        "enabled": true,
                        "children": [
                            {
                                "id": 8,
                                "name": "财务部",
                                "parentId": 5,
                                "enabled": true,
                                "children": [],
                                "parent": false
                            }],
                        "parent": true
                    }
                ],
                "parent": true
            }
        ],
        "parent": true
    }
]
```

### 存储过程调用
存储过程调用比较简单，以添加部门为例，如下：

#### 1.Mapper中添加如下方法：
```
void addDep(@Param("dep") Department department);
```
#### 2.xml中写法如下：
```
<select id="addDep" statementType="CALLABLE">
    call addDep(#{dep.name,mode=IN,jdbcType=VARCHAR},#{dep.parentId,mode=IN,jdbcType=INTEGER},#{dep.enabled,mode=IN,jdbcType=BOOLEAN},#{dep.result,mode=OUT,jdbcType=INTEGER},#{dep.id,mode=OUT,jdbcType=BIGINT})
</select>
```

注意statementType调用表示这是一个存储过程，mode=IN表示这是输入参数，mode=OUT表示这是输出参数，调用成功之后，在service中获取department的id和result字段，就能拿到相应的调用结果了。


