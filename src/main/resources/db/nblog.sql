/*
Navicat MySQL Data Transfer

Source Server         : localhost_3306
Source Server Version : 50722
Source Host           : localhost:3306
Source Database       : nblog

Target Server Type    : MYSQL
Target Server Version : 50722
File Encoding         : 65001

Date: 2019-03-23 18:41:01
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for about
-- ----------------------------
DROP TABLE IF EXISTS `about`;
CREATE TABLE `about` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `sub_title` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `site_email` varchar(255) DEFAULT NULL,
  `site_icp` varchar(255) DEFAULT NULL,
  `ping_sites` varchar(255) DEFAULT NULL,
  `meta` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of about
-- ----------------------------

-- ----------------------------
-- Table structure for article
-- ----------------------------
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `subtitle` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `keyword` varchar(255) DEFAULT NULL COMMENT '关键词',
  `img` varchar(255) DEFAULT NULL COMMENT '题图',
  `shortcut` varchar(255) DEFAULT NULL,
  `content` text,
  `words` int(11) DEFAULT NULL COMMENT '字数',
  `origin` int(11) DEFAULT NULL COMMENT '是否原创：0原创;1转载;2翻译',
  `tag_ids` varchar(255) DEFAULT NULL COMMENT '标签id',
  `category_id` bigint(20) DEFAULT NULL COMMENT '分类id',
  `special_id` bigint(20) DEFAULT NULL COMMENT '专栏id',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `deploy_time` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  `is_top` tinyint(4) DEFAULT NULL COMMENT '是否置顶：0为不置顶，1为置顶',
  `is_recommend` tinyint(4) DEFAULT NULL COMMENT '是否推荐：0为不推荐；1为推荐',
  `status` tinyint(2) DEFAULT NULL COMMENT '状态:0草稿；1：发布',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article
-- ----------------------------
INSERT INTO `article` VALUES ('19', '学习kafka教程', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '>欢迎关注公众号：n平方\n如有问题或建议，请后台留言，我会尽力解决你的问题。\n\n本文主要介绍【[Kafka Streams的架构和使用](http://kafka.apache.org/21/documentation/streams/architecture)】\n#### 目标\n* 了解kafka streams的架构。\n* 掌握kafka streams编程。\n\n#### 架构分析\n###### 总体\nKafka流通过构建Kafka生产者和消费者库，并利用Kafka的本地功能来提供数据并行性、分布式协调、容错和操作简单性，从而简化了应用程序开发。\n下图展示了一个使用Kafka Streams库的应用程序的结构。\n\n![架构图](https://upload-images.jianshu.io/upload_images/13150128-24d906be2d09a212.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n###### 流分区和任务\n\nKafka的消息传递层对数据进行分区，以存储和传输数据。Kafka流划分数据进行处理。在这两种情况下，这种分区都支持数据局部性、灵活性、可伸缩性、高性能和容错性。Kafka流使用分区和任务的概念作为基于Kafka主题分区的并行模型的逻辑单元。Kafka流与Kafka在并行性上下文中有着紧密的联系:\n* 每个流分区都是一个完全有序的数据记录序列，并映射到Kafka主题分区。\n* 流中的数据记录映射到来自该主题的Kafka消息。\n* 数据记录的键值决定了Kafka流和Kafka流中数据的分区，即，如何将数据路由到主题中的特定分区。\n\n应用程序的处理器拓扑通过将其分解为多个任务进行扩展。\n更具体地说，Kafka流基于应用程序的输入流分区创建固定数量的任务，每个任务分配一个来自输入流的分区列表(例如，kafka的topic)。分配给任务的分区永远不会改变，因此每个任务都是应用程序并行性的固定单元。\n然后，任务可以基于分配的分区实例化自己的处理器拓扑;它们还为每个分配的分区维护一个缓冲区，并从这些记录缓冲区一次处理一条消息。\n因此，流任务可以独立并行地处理，而无需人工干预。\n\n理解Kafka流不是一个资源管理器，而是一个“运行”其流处理应用程序运行的任何地方的库。应用程序的多个实例要么在同一台机器上执行，要么分布在多台机器上，库可以自动将任务分配给运行应用程序实例的那些实例。分配给任务的分区从未改变;如果应用程序实例失败，它分配的所有任务将在其他实例上自动重新启动，并继续从相同的流分区使用。\n\n下图显示了两个任务，每个任务分配一个输入流分区。\n![](https://upload-images.jianshu.io/upload_images/13150128-c189cde9b48d9a1c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n###### 线程模型\n\nKafka流允许用户配置库用于在应用程序实例中并行处理的线程数。每个线程可以独立地使用其处理器拓扑执行一个或多个任务。\n例如，下图显示了一个流线程运行两个流任务。\n\n![](https://upload-images.jianshu.io/upload_images/13150128-249692658cd90c0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n启动更多的流线程或应用程序实例仅仅相当于复制拓扑并让它处理Kafka分区的不同子集，从而有效地并行处理。值得注意的是，线程之间不存在共享状态，因此不需要线程间的协调。这使得跨应用程序实例和线程并行运行拓扑变得非常简单。Kafka主题分区在各种流线程之间的分配是由Kafka流利用Kafka的协调功能透明地处理的。\n\n如上所述，使用Kafka流扩展您的流处理应用程序很容易:您只需要启动应用程序的其他实例，Kafka流负责在应用程序实例中运行的任务之间分配分区。您可以启动与输入Kafka主题分区一样多的应用程序线程，以便在应用程序的所有运行实例中，每个线程(或者更确切地说，它运行的任务)至少有一个输入分区要处理。\n\n###### 本地状态存储\n\nKafka流提供了所谓的状态存储，流处理应用程序可以使用它来存储和查询数据，这是实现有状态操作时的一项重要功能。例如，Kafka Streams DSL在调用有状态操作符(如join()或aggregate())或打开流窗口时自动创建和管理这样的状态存储。\n\nKafka Streams应用程序中的每个流任务都可以嵌入一个或多个本地状态存储，这些存储可以通过api访问，以存储和查询处理所需的数据。Kafka流为这种本地状态存储提供容错和自动恢复功能。\n\n下图显示了两个流任务及其专用的本地状态存储。\n![](https://upload-images.jianshu.io/upload_images/13150128-cb395e3248082c3f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n###### 容错\n\nKafka流构建于Kafka中本地集成的容错功能之上。Kafka分区是高度可用和复制的;因此，当流数据持久化到Kafka时，即使应用程序失败并需要重新处理它，流数据也是可用的。Kafka流中的任务利用Kafka消费者客户端提供的容错功能来处理失败。如果任务在失败的机器上运行，Kafka流将自动在应用程序的一个剩余运行实例中重新启动该任务。\n\n此外，Kafka流还确保本地状态存储对于故障也是健壮的。对于每个状态存储，它维护一个复制的changelog Kafka主题，其中跟踪任何状态更新。这些变更日志主题也被分区，这样每个本地状态存储实例，以及访问该存储的任务，都有自己专用的变更日志主题分区。在changelog主题上启用了日志压缩，这样可以安全地清除旧数据，防止主题无限增长。如果任务在一台失败的机器上运行，并在另一台机器上重新启动，Kafka流通过在恢复对新启动的任务的处理之前重播相应的更改日志主题，确保在失败之前将其关联的状态存储恢复到内容。因此，故障处理对最终用户是完全透明的。\n\n####  编程实例\n\n###### 管道（输入输出）实例\n就是控制台输入到kafka中，经过处理输出。\n```\npackage com.example.kafkastreams.demo;\n\nimport org.apache.kafka.common.serialization.Serdes;\nimport org.apache.kafka.streams.KafkaStreams;\nimport org.apache.kafka.streams.StreamsBuilder;\nimport org.apache.kafka.streams.StreamsConfig;\nimport org.apache.kafka.streams.Topology;\n\nimport java.util.Properties;\nimport java.util.concurrent.CountDownLatch;\n\npublic class PipeDemo {\n\n    public static void main(String[] args) {\n\n        Properties props = new Properties();\n        props.put(StreamsConfig.APPLICATION_ID_CONFIG, \"streams-pipe\");\n        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, \"localhost:9092\");\n        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n\n        final StreamsBuilder builder = new StreamsBuilder();\n\n        builder.stream(\"streams-plaintext-input\").to(\"streams-pipe-output\");\n\n        final Topology topology = builder.build();\n\n        final KafkaStreams streams = new KafkaStreams(topology, props);\n        final CountDownLatch latch = new CountDownLatch(1);\n\n        // attach shutdown handler to catch control-c\n        Runtime.getRuntime().addShutdownHook(new Thread(\"streams-shutdown-hook\") {\n            @Override\n            public void run() {\n                streams.close();\n                latch.countDown();\n            }\n        });\n\n        try {\n            streams.start();\n            latch.await();\n        } catch (Throwable e) {\n            System.exit(1);\n        }\n        System.exit(0);\n    }\n\n}\n```\n\n\n###### 分词实例\n就是将你输入的字符串进行分词输出。\n\n```\npackage com.example.kafkastreams.demo;\n\nimport org.apache.kafka.common.serialization.Serdes;\nimport org.apache.kafka.streams.KafkaStreams;\nimport org.apache.kafka.streams.StreamsBuilder;\nimport org.apache.kafka.streams.StreamsConfig;\nimport org.apache.kafka.streams.Topology;\nimport org.apache.kafka.streams.kstream.KStream;\n\nimport java.util.Arrays;\nimport java.util.Properties;\nimport java.util.concurrent.CountDownLatch;\n\npublic class LineSplitDemo {\n    public static void main(String[] args) throws Exception {\n        Properties props = new Properties();\n        props.put(StreamsConfig.APPLICATION_ID_CONFIG, \"streams-linesplit\");\n        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, \"localhost:9092\");\n        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n\n        final StreamsBuilder builder = new StreamsBuilder();\n\n        KStream<String, String> source = builder.stream(\"streams-plaintext-input\");\n        source.flatMapValues(value -> Arrays.asList(value.split(\"\\\\W+\")))\n                .to(\"streams-linesplit-output\");\n\n        final Topology topology = builder.build();\n        final KafkaStreams streams = new KafkaStreams(topology, props);\n        final CountDownLatch latch = new CountDownLatch(1);\n\n\n        // attach shutdown handler to catch control-c\n        Runtime.getRuntime().addShutdownHook(new Thread(\"streams-shutdown-hook\") {\n            @Override\n            public void run() {\n                streams.close();\n                latch.countDown();\n            }\n        });\n\n        try {\n            streams.start();\n            latch.await();\n        } catch (Throwable e) {\n            System.exit(1);\n        }\n        System.exit(0);\n\n    }\n}\n\n```\n\n\n###### 词汇统计实例\n将你输入的字符串进行按单词统计输出。\n```\npackage com.example.kafkastreams.demo;\n\nimport org.apache.kafka.common.serialization.Serdes;\nimport org.apache.kafka.common.utils.Bytes;\nimport org.apache.kafka.streams.KafkaStreams;\nimport org.apache.kafka.streams.StreamsBuilder;\nimport org.apache.kafka.streams.StreamsConfig;\nimport org.apache.kafka.streams.Topology;\nimport org.apache.kafka.streams.kstream.KStream;\nimport org.apache.kafka.streams.kstream.Materialized;\nimport org.apache.kafka.streams.kstream.Produced;\nimport org.apache.kafka.streams.state.KeyValueStore;\n\nimport java.util.Arrays;\nimport java.util.Locale;\nimport java.util.Properties;\nimport java.util.concurrent.CountDownLatch;\n\npublic class WordCountDemo {\n\n    public static void main(String[] args) throws Exception {\n        Properties props = new Properties();\n        props.put(StreamsConfig.APPLICATION_ID_CONFIG, \"streams-wordcount\");\n        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, \"localhost:9092\");\n        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n\n        final StreamsBuilder builder = new StreamsBuilder();\n\n        KStream<String, String> source = builder.stream(\"streams-plaintext-input\");\n        source.flatMapValues(value -> Arrays.asList(value.toLowerCase(Locale.getDefault()).split(\"\\\\W+\")))\n                .groupBy((key, value) -> value)\n                .count(Materialized.<String, Long, KeyValueStore<Bytes, byte[]>>as(\"counts-store\"))\n                .toStream()\n                .to(\"streams-wordcount-output\", Produced.with(Serdes.String(), Serdes.Long()));\n\n        final Topology topology = builder.build();\n        final KafkaStreams streams = new KafkaStreams(topology, props);\n        final CountDownLatch latch = new CountDownLatch(1);\n\n\n        // attach shutdown handler to catch control-c\n        Runtime.getRuntime().addShutdownHook(new Thread(\"streams-shutdown-hook\") {\n            @Override\n            public void run() {\n                streams.close();\n                latch.countDown();\n            }\n        });\n\n        try {\n            streams.start();\n            latch.await();\n        } catch (Throwable e) {\n            System.exit(1);\n        }\n        System.exit(0);\n    }\n}\n\n```\n\n####  最后\n本人水平有限，欢迎各位建议以及指正。顺便关注一下公众号呗，会经常更新文章的哦。\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-894f98cf6f8bf990.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)', null, '0', null, null, '2', '2019-02-14 22:47:51', '2019-02-16 20:12:26', '2019-02-16 20:12:26', null, null, null, '0');
INSERT INTO `article` VALUES ('20', '番外篇：入门React', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '>欢迎关注公众号：n平方\n如有问题或建议，请后台留言，我会尽力解决你的问题。\n\n####  背景\n当你觉得原生js代码乱七八糟的时候，那就是要体验一下React。（**秘籍在最后**）\n\n#### 目标\n* 踢开React的大门。\n\n#### 简介\nReact 的核心思想是：封装组件。\n各个组件维护自己的状态和 UI，当状态变更，自动重新渲染整个组件。\nReact 大体包含下面这些概念：\n* 组件:\n* JSX\n* Virtual DOM\n* Data Flow\n\n**经验：**\n前端框架的基本组成：\n**组件及其生命周期、样式、路由、网络请求、事件处理、数据存储和传递。**\n\n#### HelloWorld\n```\nimport React, { Component } from \'react\';\nimport { render } from \'react-dom\';\n\nclass HelloMessage extends Component {\n  render() {\n    return <div>Hello {this.props.name}</div>;\n  }\n}\n\n// 加载组件到 DOM 元素 mountNode\nrender(<HelloMessage name=\"John\" />, mountNode);\n```\n解析：\n* **组件：**HelloMessage 就是一个 React 构建的**组件**，最后一句 render 会把这个组件显示到页面上的某个元素 mountNode 里面，显示的内容就是 <div>Hello John</div>。\n* **JSX:**  将 HTML 直接嵌入了 JS 代码里面(上面的js里就写了个div)，这个就是 React 提出的一种叫 JSX 的语法.\n\n* **Virtual DOM：**\n![虚拟DOM](https://upload-images.jianshu.io/upload_images/13150128-33fe4d0c9a0e6ba8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n当组件状态 state 有更改的时候，React 会自动调用组件的 render 方法重新渲染整个组件的 UI。\n当然如果真的这样大面积的操作 DOM，性能会是一个很大的问题，所以 React 实现了一个Virtual DOM，组件 DOM 结构就是映射到这个 Virtual DOM 上，React 在这个 Virtual DOM 上实现了一个 diff 算法，当要重新渲染组件的时候，会通过 diff 寻找到要变更的 DOM 节点，再把这个修改更新到浏览器实际的 DOM 节点上，所以实际上不是真的渲染整个 DOM 树。这个 Virtual DOM 是一个纯粹的 JS 数据结构，所以性能会比原生 DOM 快很多。\n\n* **Data Flow：**\n“单向数据绑定”是 React 推崇的一种应用架构的方式。\n\n#### 与webpack结合\n**package.json看依赖**\n```\n{\n  \"name\": \"learning-01\",\n  \"version\": \"1.0.0\",\n  \"description\": \"\",\n  \"main\": \"webpack.config.js\",\n  \"scripts\": {\n    \"test\": \"echo \\\"Error: no test specified\\\" && exit 1\",\n    \"start\": \"webpack-dev-server --config ./webpack.config.js --mode development --open\",\n    \"build\": \"webpack\"\n  },\n  \"author\": \"\",\n  \"license\": \"ISC\",\n  \"devDependencies\": {\n    \"@babel/core\": \"^7.3.3\",\n    \"@babel/preset-env\": \"^7.3.1\",\n    \"@babel/preset-react\": \"^7.0.0\",\n    \"babel-loader\": \"^8.0.5\",\n    \"clean-webpack-plugin\": \"^1.0.1\",\n    \"html-webpack-plugin\": \"^3.2.0\",\n    \"react-hot-loader\": \"^4.7.1\",\n    \"webpack\": \"^4.29.5\",\n    \"webpack-cli\": \"^3.2.3\",\n    \"webpack-dev-server\": \"^3.2.0\"\n  },\n  \"dependencies\": {\n    \"react\": \"^16.8.3\",\n    \"react-dom\": \"^16.8.3\"\n  }\n}\n```\n\n**webpack.config.js看配置**\n\n```\nconst webpack = require(\'webpack\');\nconst HtmlWebpackPlugin = require(\'html-webpack-plugin\');\nconst CleanWebpackPlugin = require(\'clean-webpack-plugin\');\n\nmodule.exports = {\n    entry: \'./src/index.js\',\n    output: {\n      path: __dirname + \'/dist\',\n      publicPath: \'/\',\n      filename: \'bundle.js\'\n    }, module: {\n      rules: [\n        {\n          test: /\\.(js|jsx)$/,\n          exclude: /node_modules/,\n          use: [\'babel-loader\']\n        }\n      ]\n    },\n    resolve: {\n      extensions: [\'*\', \'.js\', \'.jsx\']\n    },\n    plugins: [\n      new CleanWebpackPlugin([\'dist\']),\n      new webpack.HotModuleReplacementPlugin(),\n      new HtmlWebpackPlugin({template:\'index.html\'})\n    ],\n    devServer: {\n      contentBase: \'./dist\',\n      hot: true\n    }\n  };\n```\n基本搭建环境参考（可直接clone）\nhttps://github.com/xbmchina/react-learning/tree/master/learning-template\n\n#### JSX\n* 1. HTML 里的 class 在 JSX 里要写成 className，因为 class 在 JS 里是保留关键字。\n* 2.同理某些属性比如 for 要写成 htmlFor。\n* 3.属性值使用表达式，只要用 {} 替换 \"\"\n```\n// Input (JSX):\nvar person = <Person name={window.isLoggedIn ? window.name : \'\'} />;\n// Output (JS):\nvar person = React.createElement(\n  Person,\n  {name: window.isLoggedIn ? window.name : \'\'}\n);\n```\n* 4. 使用注释要用 {} 包起来。\n```\n {/* child comment, put {} around */}\n```\n* 5.React 会将所有要显示到 DOM 的字符串转义，防止 XSS。\n```\n<div dangerouslySetInnerHTML={{__html: \'cc &copy; 2015\'}} />\n```\n* 6.属性扩散\n```\nvar props = {};\nprops.foo = x;\nprops.bar = y;\nvar component = <Component {...props} />;\n```\n\n#### 组件\n######  生命周期(主要两个）\n**componentWillMount**\n只会在装载之前调用一次，在 render 之前调用，你可以在这个方法里面调用 setState 改变状态，并且不会导致额外调用一次 render\n\n**componentDidMount**\n只会在装载完成之后调用一次，在 render 之后调用，从这里开始可以通过 ReactDOM.findDOMNode(this) 获取到组件的 DOM 节点。\n```\nvar React = require(\'react\');\nvar ReactDOM = require(\'react-dom\');\nimport ComponentHeader from \'./components/ComponentHeader\';\nimport ComponentFooter from \'./components/ComponentFooter\';\nimport BodyIndex from \'./components/BodyIndex\';\nimport BasicExample from \'./root\'\n\nexport default class Index extends React.Component {\n\n constructor(props) {\n    super(props);\n    this.state = { count: props.initialCount };\n  }\n\n  //组件即将加载\n  componentWillMount() {\n    //定义你的逻辑即可\n    console.log(\"Index - componentWillMount\");\n  }\n  //组件加载完毕\n  componentDidMount() {\n    console.log(\"Index - componentDidMount\");\n  }\n\n  render() {\n\n		/*\n		var component;\n		if (用户已登录) {\n			component = <ComponentLoginedHeader/>\n		}\n		else{\n			component = <ComponentHeader/>\n		}\n		*/\n\n    return (\n      <div>\n        <ComponentHeader />\n        <BodyIndex />\n        <ComponentFooter />\n      </div>\n    );\n  }\n}\n\nReactDOM.render(<BasicExample/>,document.getElementById(\'app\'))\n```\n\n###### 事件处理\n给事件处理函数传递额外参数的方式：bind(this, arg1, arg2, ...)\n```\nrender: function() {\n    return <p onClick={this.handleClick.bind(this, \'extra param\')}>;\n},\nhandleClick: function(param, event) {\n    // handle click\n}\n```\n######  DOM操作\n**Refs**\n另外一种方式就是通过在要引用的 DOM 元素上面设置一个 ref 属性指定一个名称，然后通过 this.refs.name 来访问对应的 DOM 元素。\n\n比如有一种情况是必须直接操作 DOM 来实现的，你希望一个 <input/> 元素在你清空它的值时 focus，你没法仅仅靠 state 来实现这个功能。\n\n```\nclass App extends Component {\n  constructor() {\n    return { userInput: \'\' };\n  }\n\n  handleChange(e) {\n    this.setState({ userInput: e.target.value });\n  }\n\n  clearAndFocusInput() {\n    this.setState({ userInput: \'\' }, () => {\n      this.refs.theInput.focus();\n    });\n  }\n\n  render() {\n    return (\n      <div>\n        <div onClick={this.clearAndFocusInput.bind(this)}>\n          Click to Focus and Reset\n        </div>\n        <input\n          ref=\"theInput\"\n          value={this.state.userInput}\n          onChange={this.handleChange.bind(this)}\n        />\n      </div>\n    );\n  }\n}\n```\n\n######  组合组件\n使用组件的目的就是通过构建模块化的组件，相互组合组件最后组装成一个复杂的应用。在 React 组件中要包含其他组件作为子组件，只需要把组件当作一个 DOM 元素引入就可以了。\n\n```\nvar React = require(\'react\');\nvar ReactDOM = require(\'react-dom\');\nimport ComponentHeader from \'./components/ComponentHeader\';\nimport ComponentFooter from \'./components/ComponentFooter\';\nimport BodyIndex from \'./components/BodyIndex\';\n\nclass Index extends React.Component {\n  //组件即将加载\n  componentWillMount() {\n    //定义你的逻辑即可\n    console.log(\"Index - componentWillMount\");\n  }\n  //组件加载完毕\n  componentDidMount() {\n    console.log(\"Index - componentDidMount\");\n  }\n\n  render() {\n\n		/*\n		var component;\n		if (用户已登录) {\n			component = <ComponentLoginedHeader/>\n		}\n		else{\n			component = <ComponentHeader/>\n		}\n		*/\n\n    return (\n      <div>\n        <ComponentHeader />\n        <BodyIndex />\n        <ComponentFooter />\n      </div>\n    );\n  }\n}\n\n\nReactDOM.render(\n  <Index />, document.getElementById(\'app\'));\n```\n\n######  组件间通信\n**父子组件间通信**\n* 1.父组件传递到子组件：\n就是通过 **props 属性传递**，在父组件给子组件设置 props，然后子组件就可以通过 props 访问到父组件的数据／方法，这样就搭建起了父子组件间通信的桥梁。\n\n* 2.父组件访问子组件？\n **用 refs**\n\n**非父子组件间的通信**\n使用全局事件 Pub/Sub 模式，在 componentDidMount 里面订阅事件，在 componentWillUnmount 里面取消订阅，当收到事件触发的时候调用 setState 更新 UI。\n一般来说，对于比较复杂的应用，推荐使用类似 Flux 这种单项数据流架构\n\n###### 使用css样式\n**1.内联样式**\n\n在render函数里定义 \n```\nconst styleComponentHeader = { header: { backgroundColor: \'#333333\', color: \'#FFFFFF\', \'padding-top\': \'12px\', \'paddingBottom: \'16px\' } };\n\n```\n注意样式的驼峰写法 style = {styleComponentHeader.header}\n\n文件中引用css的样式 **注意class需要更改成className**确定是动画、伪类（hover）等不能使用\n\n**2.内联样式中的表达式**\n```\npaddingBottom：(this.state.minHeader)?\"3px\":\"15px\" \n```\n注意好好理解这里的state引起样式的即时变化\n\n**3.CSS模块化**\n\n原因：避免全局污染、命名混乱、依赖管理不彻底、无法共享变量、代码压缩不彻底\n```\nnpm install --save-dev style-loader css-loader npm install --save-dev babel-plugin-react-html-attrs  //为了使用原生的html属性名\n```\n全局样式和局部样式\n```\n:local(.normal){color:green;}  //局部样式\n:global(.btn){color:red;}  //全局样式\n```\nCSS模块化的优点 所有样式都是local的，解决了命名冲突和全局污染问题 class名生成规则配置灵活，可以此来压缩class名 只需引用组件的JS就能搞定组件所有的js和css 依然是css，几乎零学习成本\n\njsx样式与css的互转 工具：[https://staxmanade.com/CssToReact/](https://staxmanade.com/CssToReact/)\n\n###### react-router\n官网：https://reacttraining.com/react-router/web/guides/quick-start\nGitHub：https://github.com/ReactTraining/react-router\n\n注意点：\n**1.引用的包是有区别的。**\n![](https://upload-images.jianshu.io/upload_images/13150128-92f5628167bcdec8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n**2.控制页面的层级关系 单页面构建Router控制**\n底层机制 React： state/props -> Components ->UI Router: location ->Router -> UI\n\n**3.router传参**\n定义： path=\"list/:id\" 使用： this.props.match.params.id\n\n**4.地址无法刷新（巨坑）**\n表现：\'/\' 根节点 Home 显示无误，不过其他任何路由 例如 /detail，均显示 Cannot GET /detail。\n解决方法：\n* 4.1 用的 BrowserRouter 改为 HashRouter 即可\n\n* 4.2 修改 webpack.config.js 配置文件\n```\nmodule.exports = {\n    // 省略其他的配置\n    devServer: {\n        historyApiFallback: true\n    }\n}\n\n```\n详情可以参考：https://blog.csdn.net/zwkkkk1/article/details/83411071\n\n\n#### 网络请求Fetch\n官网：https://github.com/github/fetch\n```\nfetch(\'/users.json\')\n  .then(function(response) {\n    return response.json()\n  }).then(function(json) {\n    console.log(\'parsed json\', json)\n  }).catch(function(ex) {\n    console.log(\'parsing failed\', ex)\n  })\n```\n\n#### Redux\n下期再讲\n\n\n\n#### 学习资料\n---\n**练习代码**\n学习Demo样例：https://github.com/xbmchina/react-learning\n项目Demo样例：https://github.com/xbmchina/react-project-news\n\n---\n**React相关资料**\n\n**React官网：https://reactjs.org/docs/hello-world.html\nReact中文网：https://react.docschina.org/\nReact学习文档：http://caibaojian.com/react/\nwebpack搭建React:https://segmentfault.com/a/1190000018025963?utm_source=tag-newest\nReact-router官网：https://reacttraining.com/react-router/\n阿里UI库Ant Design:https://ant.design/index-cn\n阿里图标库：https://www.iconfont.cn/\n谷歌的ReactUI库：https://material-ui.com/\ncss转React:https://staxmanade.com/CssToReact/\nFetch请求：https://github.com/github/fetch**\n\n####  最后\n本人水平有限，欢迎各位建议以及指正。顺便关注一下公众号呗，会经常更新文章的哦。\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-894f98cf6f8bf990.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)', null, null, null, null, null, '2019-03-05 21:23:40', '2019-03-05 21:23:40', '2019-03-05 21:23:40', null, null, null, '0');
INSERT INTO `article` VALUES ('21', '学习kafka教程（二）', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '>欢迎关注公众号：n平方\n如有问题或建议，请后台留言，我会尽力解决你的问题。\n\n本文主要介绍【[KafkaStreams](http://kafka.apache.org/21/documentation/streams/)】\n\n#### 简介\n**Kafka Streams**编写关键任务实时应用程序和微服务的最简单方法，是一个用于构建应用程序和微服务的客户端库，其中输入和输出数据存储在Kafka集群中。它结合了在客户端编写和部署标准Java和Scala应用程序的简单性和Kafka服务器端集群技术的优点。\n\n**Kafka Streams是一个用于构建关键任务实时应用程序和微服务的客户端库，其中输入和/或输出数据存储在Kafka集群中。**Kafka Streams结合了在客户端编写和部署标准Java和Scala应用程序的简单性和Kafka服务器端集群技术的优点，使这些应用程序具有高度可伸缩性、灵活性、容错性、分布式等等。\n\n#### 目标\n* 了解kafka Streams\n* 会使用kafka Streams\n\n\n#### 过程\n**1.首先WordCountDemo示例代码(Java8以上)**\n```\n// Serializers/deserializers (serde) for String and Long types\nfinal Serde<String> stringSerde = Serdes.String();\nfinal Serde<Long> longSerde = Serdes.Long();\n \n// Construct a `KStream` from the input topic \"streams-plaintext-input\", where message values\n// represent lines of text (for the sake of this example, we ignore whatever may be stored\n// in the message keys).\nKStream<String, String> textLines = builder.stream(\"streams-plaintext-input\",\n    Consumed.with(stringSerde, stringSerde);\n \nKTable<String, Long> wordCounts = textLines\n    // Split each text line, by whitespace, into words.\n    .flatMapValues(value -> Arrays.asList(value.toLowerCase().split(\"\\\\W+\")))\n \n    // Group the text words as message keys\n    .groupBy((key, value) -> value)\n \n    // Count the occurrences of each word (message key).\n    .count()\n \n// Store the running counts as a changelog stream to the output topic.\nwordCounts.toStream().to(\"streams-wordcount-output\", Produced.with(Serdes.String(), Serdes.Long()));\n```\n\n它实现了WordCount算法，该算法从输入文本计算单词出现的直方图。然而，与您以前可能看到的对有界数据进行操作的其他WordCount示例不同，WordCount演示应用程序的行为略有不同，因为它被设计为对无限、无界的数据流进行操作。与有界变量类似，它是一种有状态算法，用于跟踪和更新单词的计数。然而，由于它必须假定输入数据可能是无界的，因此它将周期性地输出当前状态和结果，同时继续处理更多的数据，因为它不知道何时处理了“所有”输入数据。\n\n**2.安装并启动zookeeper和kafka**\n```\nbin/zookeeper-server-start.sh config/zookeeper.properties\nbin/kafka-server-start.sh config/server.properties\n```\n\n**3.创建主题**\n接下来，我们创建名为streams-plain -input的输入主题和名为streams-wordcount-output的输出主题:\n```\nbin/kafka-topics.sh --create \\\n    --zookeeper localhost:2181 \\\n    --replication-factor 1 \\\n    --partitions 1 \\\n    --topic streams-plaintext-input\nCreated topic \"streams-plaintext-input\"\n```\n我们创建启用压缩的输出主题，因为输出流是一个变更日志流.\n```\nbin/kafka-topics.sh --create \\\n    --zookeeper localhost:2181 \\\n    --replication-factor 1 \\\n    --partitions 1 \\\n    --topic streams-wordcount-output \\\n    --config cleanup.policy=compact\nCreated topic \"streams-wordcount-output\"\n```\n创建的主题也可以使用相同的kafka主题进行描述\n```\nbin/kafka-topics.sh --zookeeper localhost:2181 --describe\n```\n\n**4.启动Wordcount应用程序**\n```\nbin/kafka-run-class.sh org.apache.kafka.streams.examples.wordcount.WordCountDemo\n```\na)演示应用程序将从输入主题流(明文输入)中读取，对每个读取的消息执行WordCount算法的计算，并不断将其当前结果写入输出主题流(WordCount -output)。因此，除了日志条目之外，不会有任何STDOUT输出，因为结果是用Kafka写回去的。\n\nb)现在我们可以在一个单独的终端上启动控制台生成器，向这个主题写入一些输入数据和检查输出的WordCount演示应用程序从其输出主题与控制台消费者在一个单独的终端.\n\n```\nbin/kafka-console-consumer.sh --bootstrap-server localhost:9092 \\\n    --topic streams-wordcount-output \\\n    --from-beginning \\\n    --formatter kafka.tools.DefaultMessageFormatter \\\n    --property print.key=true \\\n    --property print.value=true \\\n    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \\\n    --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer\n```\n\nc)**输入端：**现在让我们使用控制台生成器将一些消息写入输入主题流——纯文本输入，方法是输入一行文本，然后单击。这将发送新消息输入主题,消息键为空和消息值是刚才输入的字符串编码的文本行。\n```\nbin/kafka-console-producer.sh --broker-list localhost:9092 --topic streams-plaintext-input\n```\n此时你可以在**控制台**输入如下字符：\n```\nall streams lead to kafka\n```\nd）)**输出端：**此消息将由Wordcount应用程序处理，以下输出数据将写入streams-wordcount-output主题并由控制台使用者打印:\n```\nbin/kafka-console-consumer.sh --bootstrap-server localhost:9092 \\\n    --topic streams-wordcount-output \\\n    --from-beginning \\\n    --formatter kafka.tools.DefaultMessageFormatter \\\n    --property print.key=true \\\n    --property print.value=true \\\n    --property key.deserializer=org.apache.kafka.common.serialization.StringDeserializer \\\n    --property value.deserializer=org.apache.kafka.common.serialization.LongDeserializer\n```\n这个时候会接收到刚刚在**控制台**输入的单词统计结果：\n```\nall     1\nstreams 1\nlead    1\nto      1\nkafka   1\n```\n如此类推：你可以在**输入端**输入单词，对应的在**输出端**就会有统计结果。\n\n**小结：**\n可以看到，Wordcount应用程序的输出实际上是连续的更新流，其中每个输出记录(即上面原始输出中的每一行)是单个单词的更新计数，也就是记录键，如“kafka”。对于具有相同键的多个记录，后面的每个记录都是前一个记录的更新。\n\n下面的两个图说明了幕后的本质。第一列显示KTable的当前状态的演变，该状态为count计算单词出现的次数。第二列显示KTable的状态更新所产生的更改记录，这些记录被发送到输出Kafka主题流-wordcount-output。\n\n![image.png](https://upload-images.jianshu.io/upload_images/13150128-cffe3859889ef795.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n![image.png](https://upload-images.jianshu.io/upload_images/13150128-d843ec689239a483.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n#### 最后\n本人水平有限，欢迎各位建议以及指正。顺便关注一下公众号呗，会经常更新文章的哦。\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-894f98cf6f8bf990.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n', null, null, null, null, null, '2019-03-05 21:24:21', '2019-03-05 21:24:21', '2019-03-05 21:24:21', null, null, null, '0');
INSERT INTO `article` VALUES ('22', '学习kafka教程（三）', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '>欢迎关注公众号：n平方\n如有问题或建议，请后台留言，我会尽力解决你的问题。\n\n本文主要介绍【[Kafka Streams的架构和使用](http://kafka.apache.org/21/documentation/streams/architecture)】\n#### 目标\n* 了解kafka streams的架构。\n* 掌握kafka streams编程。\n\n#### 架构分析\n###### 总体\nKafka流通过构建Kafka生产者和消费者库，并利用Kafka的本地功能来提供数据并行性、分布式协调、容错和操作简单性，从而简化了应用程序开发。\n下图展示了一个使用Kafka Streams库的应用程序的结构。\n\n![架构图](https://upload-images.jianshu.io/upload_images/13150128-24d906be2d09a212.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n###### 流分区和任务\n\nKafka的消息传递层对数据进行分区，以存储和传输数据。Kafka流划分数据进行处理。在这两种情况下，这种分区都支持数据局部性、灵活性、可伸缩性、高性能和容错性。Kafka流使用分区和任务的概念作为基于Kafka主题分区的并行模型的逻辑单元。Kafka流与Kafka在并行性上下文中有着紧密的联系:\n* 每个流分区都是一个完全有序的数据记录序列，并映射到Kafka主题分区。\n* 流中的数据记录映射到来自该主题的Kafka消息。\n* 数据记录的键值决定了Kafka流和Kafka流中数据的分区，即，如何将数据路由到主题中的特定分区。\n\n应用程序的处理器拓扑通过将其分解为多个任务进行扩展。\n更具体地说，Kafka流基于应用程序的输入流分区创建固定数量的任务，每个任务分配一个来自输入流的分区列表(例如，kafka的topic)。分配给任务的分区永远不会改变，因此每个任务都是应用程序并行性的固定单元。\n然后，任务可以基于分配的分区实例化自己的处理器拓扑;它们还为每个分配的分区维护一个缓冲区，并从这些记录缓冲区一次处理一条消息。\n因此，流任务可以独立并行地处理，而无需人工干预。\n\n理解Kafka流不是一个资源管理器，而是一个“运行”其流处理应用程序运行的任何地方的库。应用程序的多个实例要么在同一台机器上执行，要么分布在多台机器上，库可以自动将任务分配给运行应用程序实例的那些实例。分配给任务的分区从未改变;如果应用程序实例失败，它分配的所有任务将在其他实例上自动重新启动，并继续从相同的流分区使用。\n\n下图显示了两个任务，每个任务分配一个输入流分区。\n![](https://upload-images.jianshu.io/upload_images/13150128-c189cde9b48d9a1c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n###### 线程模型\n\nKafka流允许用户配置库用于在应用程序实例中并行处理的线程数。每个线程可以独立地使用其处理器拓扑执行一个或多个任务。\n例如，下图显示了一个流线程运行两个流任务。\n\n![](https://upload-images.jianshu.io/upload_images/13150128-249692658cd90c0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n启动更多的流线程或应用程序实例仅仅相当于复制拓扑并让它处理Kafka分区的不同子集，从而有效地并行处理。值得注意的是，线程之间不存在共享状态，因此不需要线程间的协调。这使得跨应用程序实例和线程并行运行拓扑变得非常简单。Kafka主题分区在各种流线程之间的分配是由Kafka流利用Kafka的协调功能透明地处理的。\n\n如上所述，使用Kafka流扩展您的流处理应用程序很容易:您只需要启动应用程序的其他实例，Kafka流负责在应用程序实例中运行的任务之间分配分区。您可以启动与输入Kafka主题分区一样多的应用程序线程，以便在应用程序的所有运行实例中，每个线程(或者更确切地说，它运行的任务)至少有一个输入分区要处理。\n\n###### 本地状态存储\n\nKafka流提供了所谓的状态存储，流处理应用程序可以使用它来存储和查询数据，这是实现有状态操作时的一项重要功能。例如，Kafka Streams DSL在调用有状态操作符(如join()或aggregate())或打开流窗口时自动创建和管理这样的状态存储。\n\nKafka Streams应用程序中的每个流任务都可以嵌入一个或多个本地状态存储，这些存储可以通过api访问，以存储和查询处理所需的数据。Kafka流为这种本地状态存储提供容错和自动恢复功能。\n\n下图显示了两个流任务及其专用的本地状态存储。\n![](https://upload-images.jianshu.io/upload_images/13150128-cb395e3248082c3f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n###### 容错\n\nKafka流构建于Kafka中本地集成的容错功能之上。Kafka分区是高度可用和复制的;因此，当流数据持久化到Kafka时，即使应用程序失败并需要重新处理它，流数据也是可用的。Kafka流中的任务利用Kafka消费者客户端提供的容错功能来处理失败。如果任务在失败的机器上运行，Kafka流将自动在应用程序的一个剩余运行实例中重新启动该任务。\n\n此外，Kafka流还确保本地状态存储对于故障也是健壮的。对于每个状态存储，它维护一个复制的changelog Kafka主题，其中跟踪任何状态更新。这些变更日志主题也被分区，这样每个本地状态存储实例，以及访问该存储的任务，都有自己专用的变更日志主题分区。在changelog主题上启用了日志压缩，这样可以安全地清除旧数据，防止主题无限增长。如果任务在一台失败的机器上运行，并在另一台机器上重新启动，Kafka流通过在恢复对新启动的任务的处理之前重播相应的更改日志主题，确保在失败之前将其关联的状态存储恢复到内容。因此，故障处理对最终用户是完全透明的。\n\n####  编程实例\n\n###### 管道（输入输出）实例\n就是控制台输入到kafka中，经过处理输出。\n```\npackage com.example.kafkastreams.demo;\n\nimport org.apache.kafka.common.serialization.Serdes;\nimport org.apache.kafka.streams.KafkaStreams;\nimport org.apache.kafka.streams.StreamsBuilder;\nimport org.apache.kafka.streams.StreamsConfig;\nimport org.apache.kafka.streams.Topology;\n\nimport java.util.Properties;\nimport java.util.concurrent.CountDownLatch;\n\npublic class PipeDemo {\n\n    public static void main(String[] args) {\n\n        Properties props = new Properties();\n        props.put(StreamsConfig.APPLICATION_ID_CONFIG, \"streams-pipe\");\n        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, \"localhost:9092\");\n        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n\n        final StreamsBuilder builder = new StreamsBuilder();\n\n        builder.stream(\"streams-plaintext-input\").to(\"streams-pipe-output\");\n\n        final Topology topology = builder.build();\n\n        final KafkaStreams streams = new KafkaStreams(topology, props);\n        final CountDownLatch latch = new CountDownLatch(1);\n\n        // attach shutdown handler to catch control-c\n        Runtime.getRuntime().addShutdownHook(new Thread(\"streams-shutdown-hook\") {\n            @Override\n            public void run() {\n                streams.close();\n                latch.countDown();\n            }\n        });\n\n        try {\n            streams.start();\n            latch.await();\n        } catch (Throwable e) {\n            System.exit(1);\n        }\n        System.exit(0);\n    }\n\n}\n```\n\n\n###### 分词实例\n就是将你输入的字符串进行分词输出。\n\n```\npackage com.example.kafkastreams.demo;\n\nimport org.apache.kafka.common.serialization.Serdes;\nimport org.apache.kafka.streams.KafkaStreams;\nimport org.apache.kafka.streams.StreamsBuilder;\nimport org.apache.kafka.streams.StreamsConfig;\nimport org.apache.kafka.streams.Topology;\nimport org.apache.kafka.streams.kstream.KStream;\n\nimport java.util.Arrays;\nimport java.util.Properties;\nimport java.util.concurrent.CountDownLatch;\n\npublic class LineSplitDemo {\n    public static void main(String[] args) throws Exception {\n        Properties props = new Properties();\n        props.put(StreamsConfig.APPLICATION_ID_CONFIG, \"streams-linesplit\");\n        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, \"localhost:9092\");\n        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n\n        final StreamsBuilder builder = new StreamsBuilder();\n\n        KStream<String, String> source = builder.stream(\"streams-plaintext-input\");\n        source.flatMapValues(value -> Arrays.asList(value.split(\"\\\\W+\")))\n                .to(\"streams-linesplit-output\");\n\n        final Topology topology = builder.build();\n        final KafkaStreams streams = new KafkaStreams(topology, props);\n        final CountDownLatch latch = new CountDownLatch(1);\n\n\n        // attach shutdown handler to catch control-c\n        Runtime.getRuntime().addShutdownHook(new Thread(\"streams-shutdown-hook\") {\n            @Override\n            public void run() {\n                streams.close();\n                latch.countDown();\n            }\n        });\n\n        try {\n            streams.start();\n            latch.await();\n        } catch (Throwable e) {\n            System.exit(1);\n        }\n        System.exit(0);\n\n    }\n}\n\n```\n\n\n###### 词汇统计实例\n将你输入的字符串进行按单词统计输出。\n```\npackage com.example.kafkastreams.demo;\n\nimport org.apache.kafka.common.serialization.Serdes;\nimport org.apache.kafka.common.utils.Bytes;\nimport org.apache.kafka.streams.KafkaStreams;\nimport org.apache.kafka.streams.StreamsBuilder;\nimport org.apache.kafka.streams.StreamsConfig;\nimport org.apache.kafka.streams.Topology;\nimport org.apache.kafka.streams.kstream.KStream;\nimport org.apache.kafka.streams.kstream.Materialized;\nimport org.apache.kafka.streams.kstream.Produced;\nimport org.apache.kafka.streams.state.KeyValueStore;\n\nimport java.util.Arrays;\nimport java.util.Locale;\nimport java.util.Properties;\nimport java.util.concurrent.CountDownLatch;\n\npublic class WordCountDemo {\n\n    public static void main(String[] args) throws Exception {\n        Properties props = new Properties();\n        props.put(StreamsConfig.APPLICATION_ID_CONFIG, \"streams-wordcount\");\n        props.put(StreamsConfig.BOOTSTRAP_SERVERS_CONFIG, \"localhost:9092\");\n        props.put(StreamsConfig.DEFAULT_KEY_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n        props.put(StreamsConfig.DEFAULT_VALUE_SERDE_CLASS_CONFIG, Serdes.String().getClass());\n\n        final StreamsBuilder builder = new StreamsBuilder();\n\n        KStream<String, String> source = builder.stream(\"streams-plaintext-input\");\n        source.flatMapValues(value -> Arrays.asList(value.toLowerCase(Locale.getDefault()).split(\"\\\\W+\")))\n                .groupBy((key, value) -> value)\n                .count(Materialized.<String, Long, KeyValueStore<Bytes, byte[]>>as(\"counts-store\"))\n                .toStream()\n                .to(\"streams-wordcount-output\", Produced.with(Serdes.String(), Serdes.Long()));\n\n        final Topology topology = builder.build();\n        final KafkaStreams streams = new KafkaStreams(topology, props);\n        final CountDownLatch latch = new CountDownLatch(1);\n\n\n        // attach shutdown handler to catch control-c\n        Runtime.getRuntime().addShutdownHook(new Thread(\"streams-shutdown-hook\") {\n            @Override\n            public void run() {\n                streams.close();\n                latch.countDown();\n            }\n        });\n\n        try {\n            streams.start();\n            latch.await();\n        } catch (Throwable e) {\n            System.exit(1);\n        }\n        System.exit(0);\n    }\n}\n\n```\n\n####  最后\n本人水平有限，欢迎各位建议以及指正。顺便关注一下公众号呗，会经常更新文章的哦。\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-894f98cf6f8bf990.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)', null, null, null, null, null, '2019-03-05 21:24:38', '2019-03-05 21:24:38', '2019-03-05 21:24:38', null, null, null, '0');
INSERT INTO `article` VALUES ('23', '学习kafka教程（四）', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '接着上一篇：【[学习kafka教程（一）](https://www.jianshu.com/p/8b2da085f7e2)】\n本文来源非原创，均来自互联网。\n**参考文章如下**：\n【kafka中文教程】：http://orchome.com/kafka/index\n【kafka：经典问题汇总】：https://blog.csdn.net/weixin_38750084/article/details/82855225\n【kafka官网】http://kafka.apache.org/documentation/\n#### 原理\n以问题的形式进行，方便面试。\n**问：1.kafka节点之间如何复制备份的？**\n**答：**\nKafka的备份的单元是partition，也就是每个partition都都会有leader partiton和follow partiton。其中leader partition是用来进行和producer进行写交互，follow从leader副本进行拉数据进行同步，从而保证数据的冗余，防止数据丢失的目的。 \n\n从节点 （副本）是如何实现和l（leader）副本进行数据同步的？\n**ISR集合**：ISR(In-Sync Replica)集合代表的是follow副本和leader副本消息相差不多的副本的集合。\n**follow副本需要满足以下两个条件 ：**\n* 1：follow副本必须和zookeeper保持连接。 \n* 2：follow副本的最后的offset和leader中最新的数据之间的大小不能超过阈值。\n\n**HighWaterMark:**用来标记当follow副本从leader副本中拉取消息并且同步到自身后，然后做在leader副本上做个HW来表明，此前的所有消息都在follow的副本上commit了\n\n**同步复制：**就是所有的follow副本都进行进行同步数据后才进行HW。这样就导致如果其中的一个follow副本不管因为网络还是其他原因导致的迟迟不能同步数据成功的话。那么HW永远也不会进行，这样直接导致follow副本复制不可用。 \n\n**异步复制：**异步复制避免了同步复制的缺点，但是不保证从leader副本拉取数据都同步到follow副本中\n\nkafka采取同步和异步的共同优点，所以使用ISR的方法。把Follow中同步慢的数据进行T除，从而保证了复制数据的速度。一句话总结就是用同步的方法，如果其中有同步数据慢的follow的情况，直接把该follow给T除。如果leader副本宕机，那么从ISR中选举出来新的leader副本。因为follow副本中都有记录HW。这样也会减少数据的丢失。Follow副本能够从leader中批量的读取数据并批量写入，从而减少了I/0的开销。\n\n\n**问：2.kafka消息是否会丢失？为什么？**\n**答：**\n消息不是特殊情况并不会丢失，在Producer端，当一个消息被发送后，producer会等待broker成功接收到消息的反馈ack（可通过参数控制等待时间），如果消息在途中丢失或是其中一个broker挂掉，producer会重新发送（可以通过参数控制是否等待所有备份节点都收到消息）\n在Consumer端看，broker端记录了partition中的一个offset值，这个值指向Consumer下一个即将消费message。当consumer收到了消息，但在处理过程中挂掉，此时consumer可以通过这个offset值重新找到上一个消息再进行处理，consumer还有权限控制这个offset值，对持久化到broker端的消息做任意处理。\n\nkafka 保证消息不丢失。原因如下有：\n\n1）生产者如果异步发送，会造成消息丢失，发送的过程中kafka会先把消息缓存起来。然后批量发送。 若批量发送之前client宕机会造成消息丢失。生产者不丢失消息需要同步发送\n\n2）kafka服务器默认异步刷盘，先刷到系统页缓存，然后再刷新到日志文件。页缓存的数据可能会丢失。解决可以同步的方式刷盘，但是这样效率很低，比rabbitmq低。\n\n 对于我说的第二点有点问题。在配置ack=all ， min.insync.replas > 1 是可以保证页缓存数据不丢失。\n\n3）关闭自动提交\n\n4）unclean.leader = false\n\n结论：如果想要确保消息不丢失，需要kafka producer配置成同步方式。选用rabbitmq。\n\n**问：3.kafka最合理的配置是什么？**\n**答：**\n请参考：http://orchome.com/472\n\n**问：4.kafka的leader选举机制是什么？**\n**答：**\nkafka动态维护了一个同步状态的副本合集，简称ISR，在这个集合中的节点都是和leader保持高度一致，任何一条消息必须被这个集合中的每个节点读取并追加到日志中，才会通知外部这个消息已经被提交了。\n因此这个集合中任何一个节点随时都可以被选为leader。\nISR在Zookeeper中维护。\nISR中有f+1个节点，就可以允许在f个节点down掉的情况下不会丢失消息并正常提供服务。\nISR的成员是动态的，如果一个节点被淘汰了，当它重新达到“同步中”的状态时，他可以重新加入ISR，这种leader的选择方式是非常快速的，适合kafka的应用场景。\n**问：5.kafka对硬件的配置有什么要求？**\n**答：**\n**操作系统：**\nKafka用Linux较好。Windows目前还不很好的支持。几件事情，这将有助于提高性能。\n两种配置可能很重要：\n 1）调升的文件描述符的数量，因为我们有很多话题和大量的连接。 \n2）调升最大套接字缓冲区大小，使这里介绍的数据中心之间的高性能数据传输。\n**磁盘和文件系统**\n\n推荐使用多种驱动来获取良好的吞吐量，而不是Kafka与应用程序日志或其他操作系统的文件系统共享相同的驱动。你可以将这些RAID驱动器一起打成一个卷或格式，并将每个驱动器作为其自己的目录。 由于Kafka有副本功能，RAID提供的冗余也可以在应用程序级别提供。这个选择有几个权衡。\n\n如果配置多个数据目录，分区将被轮询分配个数据目录。每个分区将在一个数据目录中（完全的）。如果数据在分区之间没有平衡，这将导致磁盘之间的负载不平衡。\n\nRAID可以在平衡磁盘负载之间做的更好（尽管并不是总是这样），因为它在低级别平衡负载。RAID的主要缺点是通常对写入吞吐造成很大的性能损失并减少可用的磁盘空间。\n\nRAID的另一个优点是能够容忍磁盘故障。但是，我们的经验是，重建RAID阵列I / O密集型，它有效地禁用服务器，因此不能提供很多实际可用性改进。\n\n**问：6.kafka的消息保证有几种方式？**\n**答：**\n有多种可能的消息传递保证可以提供：\nAt most once—Messages may be lost but are never redelivered.\n最多一次 — 消息可能丢失，但绝不会重发。\nAt least once—Messages are never lost but may be redelivered.\n至少一次 — 消息绝不会丢失，但有可能重新发送。\nExactly once—this is what people actually want, each message is delivered once and only once.\n正好一次 — 这是人们真正想要的，每个消息传递一次且仅一次\n\nkafka默认是保证“至少一次”传递，并允许用户通过禁止生产者重试和处理一批消息前提交它的偏移量来实现 “最多一次”传递。而“正好一次”传递需要与目标存储系统合作，但kafka提供了偏移量，所以实现这个很简单。\n\n#### 最后\n本人水平有限，欢迎各位建议以及指正。顺便关注一下公众号呗，会经常更新文章的哦。\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-894f98cf6f8bf990.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n', null, null, null, null, null, '2019-03-05 21:24:57', '2019-03-05 21:24:57', '2019-03-05 21:24:57', null, null, null, '0');
INSERT INTO `article` VALUES ('24', '谈谈Zookeeper', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 简介\nZooKeeper是一种高性能的分布式应用协调服务。它在一个简单的接口中公开公共服务，例如命名、配置管理、同步和组服务，这样你就不必从头编写它们。你可以使用它来实现共识、组管理、领导人选举和到场协议。您可以根据自己的特定需要在此基础上进行构建。\n\n**特点**\n>* 顺序一致性——来自客户机的更新将按照发送的顺序应用。\n>* 原子性——更新成功或失败。没有部分结果。\n>* 单个系统映像——客户机将看到服务的相同视图，而不管它连接到哪个服务器。\n>* 可靠性——一旦更新被应用，它将从那时起一直持续到客户端覆盖更新。\n>* 及时性——保证客户对系统的看法在一定的时间范围内是最新的。\n\n\n#### 目标\n* 了解基本原理\n* 掌握基本使用。\n\n#### 原理\n**1.设计目标**\nZooKeeper允许分布式进程通过类似于标准文件系统的共享层次命名空间相互协调。名称空间由数据寄存器(ZooKeeper中称为znodes)组成，这些寄存器类似于文件和目录。与设计用于存储的典型文件系统不同，ZooKeeper数据保存在内存中，这意味着ZooKeeper可以获得高吞吐量和低延迟数。\n\n![zookeeper服务架构](https://upload-images.jianshu.io/upload_images/13150128-111c2725450ef042.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n服务器必须相互了解。它们在内存中维护状态映像，以及持久存储中的事务日志和快照。只要大部分服务器可用，ZooKeeper服务就会可用。\n客户端连接到单个ZooKeeper服务器。客户机维护一个TCP连接，通过该连接发送请求、获取响应、获取监视事件和发送心跳。如果到服务器的TCP连接中断，客户机将连接到另一个服务器。\n\n**2.数据模型**\n![数据模型](https://upload-images.jianshu.io/upload_images/13150128-c5ffad0ff6ea5ad5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\nZooKeeper提供的名称空间与标准文件系统非常相似。名称是用斜杠(/)分隔的路径元素序列。ZooKeeper名称空间中的每个节点都由一个路径标识。\n\n**3.节点和短暂的节点**\n存储在名称空间中的每个znode上的数据都是按原子方式读写的。read获取与znode关联的所有数据字节，write替换所有数据。每个节点都有一个访问控制列表(ACL)，它限制谁可以做什么。\nZooKeeper也有短暂节点的概念。只要创建znode的会话处于活动状态，这些znode就存在。当会话结束时，删除znode。当您希望实现时，临时节点非常有用。\n\n**4.条件更新和监视**\nznode可以被监控，包括这个目录节点中存储的数据的修改，子节点目录的变化等，一旦变化可以通知设置监控的客户端，这个是zookeeper的核心特性，zookeeper的很多功能都是基于这个特性实现的。\n\n**5.zkServer中的角色**\n根据其身份特性分为三种\n**leader**：负责客户端的writer类型请求。\n**follower**：负责客户端的reader类型请求，参与leader选举等。\n**observer**：特殊的”follower“，其可以接受客户端reader请求，但不参与选举。（扩容系统支撑能力，提高了读取速度。因为它不接受任何同步的写入请求，只负责与leader同步数据）\n\n其中**Follower**和**observer**又统称**learner**\n\n#### 使用\n**1.安装教程**\n我就不做重复介绍\n参考链接：\nhttps://www.cnblogs.com/huangjianping/p/8012580.html\n\n**2.Java连接操作**\n官网操作：\nhttp://zookeeper.apache.org/doc/current/javaExample.html#sc_design\n\n**推荐使用Curator的方式**\n```\npublic class CuratorUtil {\n\n    /** zookeeper地址 */\n    static final String CONNECT_ADDR = \"120.79.226.4:2181\";\n    /** session超时时间 */\n    static final int SESSION_OUTTIME = 5000;//ms\n\n    public static void main(String[] args) throws Exception {\n\n        //1 重试策略：初试时间为1s 重试10次\n        RetryPolicy retryPolicy = new ExponentialBackoffRetry(1000, 10);\n        //2 通过工厂创建连接\n        CuratorFramework cf = CuratorFrameworkFactory.builder()\n                .connectString(CONNECT_ADDR)\n                .sessionTimeoutMs(SESSION_OUTTIME)\n                .retryPolicy(retryPolicy)\n//					.namespace(\"super\")\n                .build();\n        //3 开启连接\n        cf.start();\n\n        System.out.println(ZooKeeper.States.CONNECTED);\n        System.out.println(cf.getState());\n\n        // 新加、删除\n        /**\n         //4 建立节点 指定节点类型（不加withMode默认为持久类型节点）、路径、数据内容	*/\n//		cf.create().creatingParentsIfNeeded().withMode(CreateMode.PERSISTENT).forPath(\"/super/c1\",\"c1内容\".getBytes());\n        //5 删除节点\n//		cf.delete().guaranteed().deletingChildrenIfNeeded().forPath(\"/super\");\n\n\n        // 读取、修改\n        /**\n         //创建节点		*/\n//		cf.create().creatingParentsIfNeeded().withMode(CreateMode.PERSISTENT).forPath(\"/super/c1\",\"c1内容\".getBytes());\n//		cf.create().creatingParentsIfNeeded().withMode(CreateMode.PERSISTENT).forPath(\"/super/c2\",\"c2内容\".getBytes());\n        //读取节点\n//		String ret1 = new String(cf.getData().forPath(\"/super/c2\"));\n//		System.out.println(ret1);\n        //修改节点\n//		cf.setData().forPath(\"/super/c2\", \"修改c2内容\".getBytes());\n//		String ret2 = new String(cf.getData().forPath(\"/super/c2\"));\n//		System.out.println(ret2);\n\n\n        // 绑定回调函数\n        /**\n         ExecutorService pool = Executors.newCachedThreadPool();\n         cf.create().creatingParentsIfNeeded().withMode(CreateMode.PERSISTENT)\n         .inBackground(new BackgroundCallback() {\n        @Override\n        public void processResult(CuratorFramework cf, CuratorEvent ce) throws Exception {\n        System.out.println(\"code:\" + ce.getResultCode());\n        System.out.println(\"type:\" + ce.getType());\n        System.out.println(\"线程为:\" + Thread.currentThread().getName());\n        }\n        }, pool)\n         .forPath(\"/super/c3\",\"c3内容\".getBytes());\n         Thread.sleep(Integer.MAX_VALUE);\n         */\n\n\n        // 读取子节点getChildren方法 和 判断节点是否存在checkExists方法\n        /**\n         List<String> list = cf.getChildren().forPath(\"/super\");\n         for(String p : list){\n         System.out.println(p);\n         }\n\n         Stat stat = cf.checkExists().forPath(\"/super/c3\");\n         System.out.println(stat);\n\n         Thread.sleep(2000);\n         cf.delete().guaranteed().deletingChildrenIfNeeded().forPath(\"/super\");\n         */\n\n\n        //cf.delete().guaranteed().deletingChildrenIfNeeded().forPath(\"/super\");\n\n    }\n}\n\n```\n\n\n#### 总结\nzookeeper是一个基于观察者模式设计的分布式管理框架，它负责存储和管理大家都关心的数据，然后接受观察者的注册，一旦这些数据的状态发生变化，zk就将负责通知已经在zk上注册的那些观察者做出相应的反应，从而实现集群中类似Master/Slave管理模式。\n**应用场景：**\n* 配置管理\n* 集群管理\n* 发布与订阅\n* 数据库切换\n* 分布式日志的收集\n* 分布式锁、队列管理等。\n\n更多的使用是直接配合其他框架一起使用的。如Hadoop、kafka、dubbo.\n\n\n#### 最后\n本人水平有限，欢迎各位建议以及指正，顺便关注一下公众号呗，会经常更新文章的哦。\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-894f98cf6f8bf990.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n', null, null, null, null, null, '2019-03-05 21:25:15', '2019-03-05 21:25:15', '2019-03-05 21:25:15', null, null, null, '0');
INSERT INTO `article` VALUES ('25', 'Springboot发送邮件', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 简介\nSpring提供了非常好用的 JavaMailSender接口实现邮件发送。在Spring Boot的Starter模块中也为此提供了自动化配置。下面通过实例看看如何在Spring Boot中使用 JavaMailSender 发送邮件。\n\n\n#### 目标\n* 实现发送简单的邮件发送\n* 实现发送带附件的邮件发送\n\n\n#### 过程\n**1.导入依赖**\nspring提供了操作邮箱的相关工具包。开箱即用（哈哈哈）,添加相关依赖如下：\n```\n<dependency>\n	<groupId>org.springframework.boot</groupId>\n	<artifactId>spring-boot-starter-mail</artifactId>\n</dependency>\n```\n\n**2.邮箱配置**\n既然要发送邮件，那么你肯定能够想到这里是需要配置你邮箱的账号和密码的，要不然你是想随便就能发的么（想想都觉得不合理）。所以相关yml配置文件如下：\n\n```\n  #邮箱配置\n  spring:\n    mail:\n      host: smtp.163.com\n      #发送者邮箱账号\n      username: 你的邮箱@163.com\n      #发送者密钥\n      password: 你的密钥\n      default-encoding: utf-8\n      port: 465   #端口号465或587\n      protocol: smtp\n      properties:\n        mail:\n          debug:\n            false\n          smtp:\n            socketFactory:\n              class: javax.net.ssl.SSLSocketFactory\n```\n\n这里有个地方需要注意的就是那个密码password用你自己平时登陆的密码可能不行。那么你可以参考以下的**邮箱授权**配置如下图：\n\n![邮箱授权码](https://upload-images.jianshu.io/upload_images/13150128-2882b57d6aad295d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n**3.邮箱操作服务类**\n此处有几个点需要注意的\n>* mail.mime.splitlongparameters :这个是为了禁用附件名过长会被自动截取的功能\n> *  @Async ：由于发送邮件是调用第三方的接口，如果你加上带附件的话，此处就需要特别长的时间，所以Async 是为了**异步处理**，而**快速返回响应客户端**，等处理完成再提醒发送是否成功。\n\n**具体操作如下**\n```\n@Service\npublic class MailService {\n\n    private final Logger logger = LoggerFactory.getLogger(this.getClass());\n\n    @Autowired\n    private JavaMailSender javaMailSender;\n\n    @Value(\"${spring.mail.username}\")\n    private String from;\n\n    private static String projectPath = StringUtils\n            .substringBefore(System.getProperty(\"user.dir\").replaceAll(\"\\\\\\\\\", \"/\"), \"/\");\n\n\n    static {\n        System.setProperty(\"mail.mime.splitlongparameters\", \"false\");\n    }\n\n\n    /**\n     * 发送简易邮件\n     */\n    @Async\n    public void sendSimpleMail(MailBean mailBean) throws Exception {\n        SimpleMailMessage message = new SimpleMailMessage();\n        message.setFrom(from);//发送方\n        message.setTo(mailBean.getReceiver().split(\";\"));//接收者\n        message.setSubject(mailBean.getSubject());//主题\n        message.setText(mailBean.getContent());//内容\n        javaMailSender.send(message);\n        logger.info(\"简单邮件已经发送。\");\n    }\n\n\n\n\n    /**\n     * 发送带多附件的邮件\n     *\n     * @param mailBean\n     * @throws Exception\n     */\n    @Async\n    public void sendMultiAttachmentsMail(MailBean mailBean) throws Exception {\n\n        MimeMessage message = javaMailSender.createMimeMessage();\n        // true表示需要创建一个multipart message\n        MimeMessageHelper helper = new MimeMessageHelper(message, true);\n        helper.setFrom(from);\n        helper.setTo(mailBean.getReceiver().split(\";\"));\n        helper.setSubject(mailBean.getSubject());\n        helper.setText(mailBean.getContent());\n\n        String[] files = mailBean.getAttachment().split(\"\\\\|\");\n        for (String fileName : files) {\n            String path = projectPath + \"/temp/\" + fileName;\n            FileSystemResource file = new FileSystemResource(path);\n            if (file.exists() && file.isFile()) {\n                helper.addAttachment(fileName, file);\n            }\n        }\n\n        javaMailSender.send(message);\n        logger.info(\"带附件的邮件已经发送。\");\n    }\n\n\n    /**\n     * 发送邮件-邮件正文是HTML\n     *\n     * @param mailBean\n     * @throws Exception\n     */\n    @Async\n    public void sendMailHtml(MailBean mailBean) throws Exception {\n\n        MimeMessage mimeMessage = javaMailSender.createMimeMessage();\n        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);\n\n        helper.setFrom(from);\n        helper.setTo(mailBean.getReceiver().split(\";\"));\n        helper.setSubject(mailBean.getSubject());\n        helper.setText(mailBean.getContent(), true);\n\n        javaMailSender.send(mimeMessage);\n\n    }\n\n    /**\n     * 内联资源（静态资源）邮件发送 由于邮件服务商不同，可能有些邮件并不支持内联资源的展示 在测试过程中，新浪邮件不支持，QQ邮件支持\n     * 不支持不意味着邮件发送不成功，而且内联资源在邮箱内无法正确加载\n     *\n     * @param mailBean\n     * @throws Exception\n     */\n    @Async\n    public void sendMailInline(MailBean mailBean) throws MessagingException {\n\n        MimeMessage mimeMessage = javaMailSender.createMimeMessage();\n        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);\n\n        helper.setFrom(from);\n        helper.setTo(mailBean.getReceiver().split(\";\"));\n        helper.setSubject(mailBean.getSubject());\n\n//        helper.setText(mailBean.getContent(),true);\n        //        helper.addInline();\n        helper.setText(\"my text <img src=\'cid:myLogo\'>\", true);\n        helper.addInline(\"myLogo\", new ClassPathResource(\"img/mylogo.gif\"));\n        javaMailSender.send(mimeMessage);\n\n//        mailSender.send(new MimeMessagePreparator() {\n//            public void prepare(MimeMessage mimeMessage) throws MessagingException {\n//                MimeMessageHelper message = new MimeMessageHelper(mimeMessage, true, \"UTF-8\");\n//                message.setFrom(\"me@mail.com\");\n//                message.setTo(\"you@mail.com\");\n//                message.setSubject(\"my subject\");\n//                message.setText(\"my text <img src=\'cid:myLogo\'>\", true);\n//                message.addInline(\"myLogo\", new ClassPathResource(\"img/mylogo.gif\"));\n//                message.addAttachment(\"myDocument.pdf\", new ClassPathResource(\"doc/myDocument.pdf\"));\n//            }\n//        });\n\n    }\n\n    /**\n     * 模板邮件发送\n     *\n     * @param mailBean\n     * @throws Exception\n     */\n    @Async\n    public void sendMailTemplate(MailBean mailBean) throws MessagingException {\n\n        MimeMessage mimeMessage = javaMailSender.createMimeMessage();\n        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);\n        helper.setFrom(from);\n        helper.setTo(mailBean.getReceiver().split(\";\"));\n        helper.setSubject(mailBean.getSubject());\n        helper.setText(mailBean.getContent(), true);\n        javaMailSender.send(mimeMessage);\n\n    }\n}\n```\n\n**4.页面参考如下**\n普通的表单提交加上多附件上传。\n```\n<!DOCTYPE html>\n<html>\n<head>\n    <meta charset=\"utf-8\">\n    <title>邮件发送</title>\n    <link rel=\"stylesheet\" href=\"https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css\">\n    <script src=\"https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js\"></script>\n    <script src=\"https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js\"></script>\n</head>\n<body>\n<div style=\"margin-left: 20px;\">\n    <form role=\"form\">\n        <div class=\"form-group\">\n            <label>收件人</label>\n            <input style=\"width: 300px;\" type=\"text\" class=\"form-control\" id=\"receiver\" name=\"receiver\"\n                   placeholder=\"收件人\">\n        </div>\n        <div class=\"form-group\">\n            <label>主题</label>\n            <input style=\"width: 300px;\" type=\"text\" class=\"form-control\" id=\"subject\" name=\"subject\" placeholder=\"主题\">\n        </div>\n        <div class=\"form-group\">\n            <label>内容</label>\n            <input style=\"width: 300px;\" type=\"text\" class=\"form-control\" id=\"content\" name=\"content\" placeholder=\"内容\">\n        </div>\n        <div class=\"form-group\">\n            <label>附件</label>\n            <form>\n                <input  type=\"file\" multiple id=\"file\" name=\"file[]\" >\n                <input  type=\"button\" id=\"btn\" value=\"上传\"/>\n            </form>\n            <input type=\"hidden\" id=\"attachment\" name=\"attachment\">\n        </div>\n\n        <button type=\"submit\" id=\"send\" class=\"btn btn-default\">提交</button>\n    </form>\n</div>\n<script>\n    $(function () {\n        $(\'#send\').click(function () {\n            var d = {};\n            var t = $(\'form\').serializeArray();\n            $.each(t, function () {\n                d[this.name] = this.value;\n            });\n            console.log(JSON.stringify(d));\n\n            $.ajax({\n                type: \"POST\",\n                url: \"/mail/send\",\n                data: JSON.stringify(d),\n                cache: false,\n                contentType: \"application/json; charset=utf-8\",\n                dataType: \"json\",\n                success: function (data) {\n                    alert(data.message);\n                },\n                error: function (err) {\n                    alert(err);\n                }\n            });\n        });\n\n        $(\"#btn\").click(function(){\n\n            var formData = new FormData();\n            for(var i=0; i<$(\'#file\')[0].files.length;i++){\n                formData.append(\'file\', $(\'#file\')[0].files[i]);\n            }\n\n            $.ajax({\n                type: \"POST\",\n                data: formData,\n                url: \"/mail/upload\",\n                contentType: false,\n                processData: false,\n            }).success(function (res) {\n                var data = res.data;\n                if (res.status) {\n                    var attachUrls = \"\";\n                    for(var i = 0;i<data.length;i++){\n                        var item = data[i];\n                        attachUrls += item.url+\"|\";\n                    }\n                    $(\"#attachment\").val(attachUrls);\n                    console.log(attachUrls);\n                } else {\n                    console.log(res.message);\n                }\n            }).error(function (data) {\n                alert(data);\n                console.log(data);\n            });\n\n        });\n\n    });\n</script>\n</body>\n</html>\n```\n\n#### 成果\n体验地址：http://120.79.226.4/mail-demo/\n源码地址：https://github.com/xbmchina/mail-demo\n\n\n#### 结语\n水瓶有限，所以一直在喝水。欢迎各位建议以及指正，顺便关注一下公众号呗，会经常更新文章的哦，虽然现在文字还是不够高大上。\n\n![n平方](https://upload-images.jianshu.io/upload_images/13150128-c3a2656ef004211b.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n\n\n\n', null, null, null, null, null, '2019-03-05 21:26:17', '2019-03-05 21:26:17', '2019-03-05 21:26:17', null, null, null, '0');
INSERT INTO `article` VALUES ('26', '文件上传与下载', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 文件上传和下载\n文件上传和下载是JAVA WEB中常见的一种操作，文件上传主要是将文件通过IO流传输到服务器的某一个特定的文件夹下；刚开始工作那会一个上传文件常常花费小半天的时间。自从有了springboot之后，简单到小学生都会的操作。废话不说，直接开始。\n\n#### 上传\n上传操作进行封装，根据上传的文件，以及指定的文件路径保存到本地。\n```\npublic class UploadUtil {\n\n    private static String projectPath = StringUtils.substringBefore(System.getProperty(\"user.dir\").replaceAll(\"\\\\\\\\\", \"/\"),\"/\");\n\n    /**\n     * 自定义上传路径和下载路径进行上传\n     * @param files	文件\n     * @param uploadPath 上传到路径\n     * @return\n     * @throws Exception\n     */\n    public static Map<String, Object> upload(MultipartFile[] files, String uploadPath) throws Exception {\n        Map<String, Object> retMap = new HashMap<>();\n        if (files != null && files.length > 0) {\n            List<UploadVo> fileList = new ArrayList<>();\n            for (MultipartFile file : files) {\n                UploadVo entity = new UploadVo();\n                String fileName = file.getOriginalFilename();\n                String path = projectPath + uploadPath + fileName;\n                File dest = new File(path);\n                if (!dest.getParentFile().exists()) {\n                    dest.getParentFile().mkdirs();\n                }\n                file.transferTo(dest);\n                entity.setName(fileName);\n                entity.setUrl(fileName);\n                fileList.add(entity);\n            }\n            retMap.put(\"data\", fileList);\n            retMap.put(\"success\", true);\n        } else {\n            retMap.put(\"data\", null);\n            retMap.put(\"success\", false);\n        }\n        return retMap;\n    }\n}\n```\n\n#### 下载\n根据需要下载的文件路径，从本地获取相关文件进行下载。这里特别需要注意的是中文文件的乱码问题，否则容易导致下载到的文件格式以及名称会有不同。\n\n**题外话：**\n如果你想将资源分享的话，是可以通过这个原理，将你自己的文件夹及文件展示给别人下载哦。\n\n```\npublic class DownloadUtil {\n\n    /**\n     * 按路径进行下载\n     * @param path\n     * @param request\n     * @param response\n     * @throws Exception\n     */\n    public static void download(String path, HttpServletRequest request, HttpServletResponse response) throws Exception {\n        try {\n            Path file = Paths.get(path);\n            if (Files.exists(file)) {\n                String contentType = Files.probeContentType(Paths.get(path));\n                response.setContentType(contentType);\n                String filename = new String(file.getFileName().toString().getBytes(\"UTF-8\"), \"ISO-8859-1\");\n                response.addHeader(\"Content-Disposition\", String.format(\"attachment; filename=\\\"%s\\\"\", filename));\n                response.setCharacterEncoding(\"UTF-8\");\n                Files.copy(file, response.getOutputStream());\n            }\n        } catch (Exception e) {\n            e.printStackTrace();\n        }\n    }\n}\n```\n\n\n#### 成果\n效果欠佳，还望谅解\n**体验地址：** http://120.79.226.4:8080/\n\n下一次弄个类似百度网盘的上传下载的。\n\n**源码:**\nhttps://github.com/xbmchina/upload-template', null, null, null, null, null, '2019-03-05 21:26:33', '2019-03-05 21:26:33', '2019-03-05 21:26:33', null, null, null, '0');
INSERT INTO `article` VALUES ('27', 'Nginx使用总结', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### Nginx简介\nNginx是一款轻量级的Web 服务器/反向代理服务器及电子邮件（IMAP/POP3）代理服务器，并在一个BSD-like 协议下发行。其特点是占有内存少，并发能力强，事实上nginx的并发能力确实在同类型的网页服务器中表现较好\n\n\n#### Nginx应用场景\n* 静态资源Web服务\n* 内容分发网络\n* 浏览器缓存\n* 跨站访问\n* 防盗链\n* 代理服务\n* 负载均衡服务\n\n\n#### Nginx安装（centos）\n**安装教程：**http://nginx.org/en/linux_packages.html#stable\n\nnginx是由C语言写，所以需要在centos系统中安装相关解析库。\n```\nyum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel\n```\n**步骤**\n```\nvim /etc/yum.repos.d/nginx.repo \n```\n\n**输入：**可以理解为Nginx的下载地址\n```\nname=nginx repo\nbaseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/\ngpgcheck=0\nenabled=1\n```\n\n**安装**\nyum install nginx\n控制台没报错，就没问题了。\n\n**常用命令**\n查看版本: nginx -v   \n查看安装的路径以及配置文件的路径: rpm -ql nginx \n启动：\n```\n/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf\n```\n重启：\n```\n/usr/local/nginx/sbin/nginx -s reload -c /usr/local/nginx/conf/nginx.conf\n```\n关闭：\n```\n/usr/local/nginx/sbin/nginx -s stop /usr/local/nginx/conf/nginx.conf\n```\n\n#### Nginx配置\n安装完成后，还需做好相关配置才能进行使用。\n其中主要的配置文件就是nginx.conf \n```\ncd /etc/nginx/nginx.conf \n```\n这个配置文件不用动，看最后一行   \n\n**nginx.conf**\n```\nuser  nginx;\nworker_processes  1;\n\nerror_log  /var/log/nginx/error.log warn;\npid        /var/run/nginx.pid;\n\n\nevents {\n    worker_connections  1024;\n}\n\n\nhttp {\n    include       /etc/nginx/mime.types;\n    default_type  application/octet-stream;\n\n    log_format  main  \'$remote_addr - $remote_user [$time_local] \"$request\" \'\n                      \'$status $body_bytes_sent \"$http_referer\" \'\n                      \'\"$http_user_agent\" \"$http_x_forwarded_for\"\';\n\n    access_log  /var/log/nginx/access.log  main;\n    sendfile        on;\n    #tcp_nopush     on;\n    keepalive_timeout  65;\n    #gzip  on;\n    include /etc/nginx/conf.d/*.conf;\n}\n```\n从nginx.conf的最后一行配置可以看到，只需去该目录/etc/nginx/conf.d/下新增自己的配置文件就能完成。\n\n\n\n#### 自定义配置\n在/etc/nginx/conf.d目录下添加你自定义的配置。可以参考以下的\n\n**my_server.conf**\n```\nserver {\n    listen       80;\n    server_name  localhost 120.79.226.4;\n\n    sendfile on;\n    #charset koi8-r;\n    access_log  /var/log/nginx/host.access.log  main;\n\n    ### 反向代理，此处是80端口，可以代理8080端口中的数据。\n    location ~ /my_proxy.html$ {\n        proxy_pass http://127.0.0.1:8080;\n    }\n\n    ### 设置防盗链\n    location ~ .*\\.(jpg|gif|png)$ {\n\n        #gzip on;       #gzip压缩\n        #gzip_http_version 1.1;\n        #gzip_comp_level 2;\n        #gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;\n        \n        valid_referers none blocked 120.79.226.4;\n        if ($valid_referer) {\n            return 403;\n        }\n        root /opt/app/code/images;\n    }\n\n\n    ### 压缩图片\n    location ~ .*\\.(jpg|gif|png)$ {\n        #gzip on;       #gzip压缩\n        #gzip_http_version 1.1;\n        #gzip_comp_level 2;\n        #gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;\n        \n\n        root /opt/app/code/images;\n    }\n\n    ### 压缩文本\n    location ~ .*\\.(txt|xml)$ {\n        #gzip on;   #gzip压缩\n        #gzip_http_version 1.1;\n        #gzip_comp_level 2;\n        #gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;\n        root /opt/app/code/doc;\n    }    \n\n    ### 解压缩\n    location ~ ^/download {\n        gzip_static on; #可读取.gz文件，不推荐。\n        tcp_nopush on;\n        root /opt/app/code;\n    }    \n\n    ### 缓存\n    #location ~ .*\\.(htm|html)$ {\n    #   expires 24h;#过期时间，缓存\n    #   root /opt/app/code;\n    #}\n\n    ### 跨域访问\n    location ~ .*\\.(htm|html)$ {\n        #add_header Access-Control-Allow-Origin http://www.xbmchina.cn;\n        #add_header Access-Control-Allow-Methods GET,POST,PUT,DELETE,OPTIONS;\n        root /opt/app/code;\n    }\n\n    location / {\n        root   /usr/share/nginx/html;\n        index  index.html index.htm;\n    }\n\n    #error_page  404              /404.html;\n\n    # redirect server error pages to the static page /50x.html\n    #\n    error_page   500 502 503 504  /50x.html;\n    location = /50x.html {\n        root   /usr/share/nginx/html;\n    }\n\n    # proxy the PHP scripts to Apache listening on 127.0.0.1:80\n    #\n    #location ~ \\.php$ {\n    #    proxy_pass   http://127.0.0.1;\n    #}\n\n    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000\n    #\n    #location ~ \\.php$ {\n    #    root           html;\n    #    fastcgi_pass   127.0.0.1:9000;\n    #    fastcgi_index  index.php;\n    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;\n    #    include        fastcgi_params;\n    #}\n\n    # deny access to .htaccess files, if Apache\'s document root\n    # concurs with nginx\'s one\n    #\n    #location ~ /\\.ht {\n    #    deny  all;\n    #}\n}\n```\n\n#### 成果\n访问静态资源：http://120.79.226.4/gz.jpg\n其他的成果需要相应的场景才能体现，暂无法展现。从上可以看得出Nginx其实就可以搭建一个服务器。', null, null, null, null, null, '2019-03-05 21:26:49', '2019-03-05 21:26:49', '2019-03-05 21:26:49', null, null, null, '0');
INSERT INTO `article` VALUES ('28', 'Springboot集成ueditor', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### ueditor\nueditor是百度开源的富文本编辑器。使用教程可以参考官网。\n[ueditor JPS版下载地址](https://ueditor.baidu.com/website/download.html)\n\n\n#### Springboot创建项目\n\n1. 将ueditor下载的放到static目录下，里面有个index.html的demo，可参考。\n![ueditor.png](https://upload-images.jianshu.io/upload_images/13150128-fd600d8e36a37858.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n2. templates目录下的index.html\n```html\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"\n        \"http://www.w3.org/TR/html4/loose.dtd\">\n<html>\n<head>\n    <title>完整demo</title>\n    <meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\"/>\n    <script type=\"text/javascript\" charset=\"utf-8\" src=\"/ueditor/ueditor.config.js\"></script>\n    <script type=\"text/javascript\" charset=\"utf-8\" src=\"/ueditor/ueditor.all.min.js\"> </script>\n    <!--建议手动加在语言，避免在ie下有时因为加载语言失败导致编辑器加载失败-->\n    <!--这里加载的语言文件会覆盖你在配置项目里添加的语言类型，比如你在配置项目里配置的是英文，这里加载的中文，那最后就是中文-->\n    <script type=\"text/javascript\" charset=\"utf-8\" src=\"/ueditor/lang/zh-cn/zh-cn.js\"></script>\n\n    <style type=\"text/css\">\n        div{\n            width:100%;\n        }\n    </style>\n</head>\n<body>\n<div>\n    <form action=\"/ueditor/uploadContent.action\" method=\"post\">\n        <script type=\"text/plain\" id=\"uploadEditor\" name=\"myContent\">\n        </script>\n        <input type=\"submit\" name=\"submit\" value=\"提交\">\n    </form>\n\n</div>\n\n<script type=\"text/javascript\">\n\n    //实例化编辑器\n    var ue = UE.getEditor(\'uploadEditor\',{\n        enableAutoSave:false,\n        autoHeightEnabled: true,\n        autoFloatEnabled: true,\n        scaleEnabled:true,//滚动条\n        initialFrameHeight:400 //默认的编辑区域高度\n    });\n\n    UE.Editor.prototype._bkGetActionUrl = UE.Editor.prototype.getActionUrl;\n    UE.Editor.prototype.getActionUrl = function(action) {\n        if (action == \'uploadimage\' || action == \'uploadscrawl\' || action == \'uploadimage\') {\n            return \'http://localhost:8080/ueditor/imgUpdate\'; //在这里返回我们实际的上传图片地址\n        } else {\n            return this._bkGetActionUrl.call(this, action);\n        }\n    }\n\n</script>\n</body>\n</html>\n```\n\n3. js目录下的config.json 修改图片的访问地址\n\n![config.json配置.png](https://upload-images.jianshu.io/upload_images/13150128-c35aaef5c5b6810f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n4. ueditor目录下的ueditor.config.js 配置读取上传图片的配置。\n\n![读取配置的地址.png](https://upload-images.jianshu.io/upload_images/13150128-ba3cffa537fc108a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n5. 上传接口相关Controller代码\n\n```java\n\n@Controller\n@RequestMapping(\"/ueditor\")\npublic class FileController {\n    @RequestMapping(value = \"/file\")\n    @ResponseBody\n    public String file(HttpServletRequest request) {\n        String s = \"{\\n\" +\n                \"            \\\"imageActionName\\\": \\\"uploadimage\\\",\\n\" +\n                \"                \\\"imageFieldName\\\": \\\"file\\\", \\n\" +\n                \"                \\\"imageMaxSize\\\": 2048000, \\n\" +\n                \"                \\\"imageAllowFiles\\\": [\\\".png\\\", \\\".jpg\\\", \\\".jpeg\\\", \\\".gif\\\", \\\".bmp\\\"], \\n\" +\n                \"                \\\"imageCompressEnable\\\": true, \\n\" +\n                \"                \\\"imageCompressBorder\\\": 1600, \\n\" +\n                \"                \\\"imageInsertAlign\\\": \\\"none\\\", \\n\" +\n                \"                \\\"imageUrlPrefix\\\": \\\"\\\",\\n\" +\n                \"                \\\"imagePathFormat\\\": \\\"/ueditor/jsp/upload/image/{yyyy}{mm}{dd}/{time}{rand:6}\\\" }\";\n        return s;\n    }\n\n    @RequestMapping(value = \"/imgUpdate\")\n    @ResponseBody\n    public String imgUpdate(MultipartFile file, HttpServletRequest request) throws FileNotFoundException {\n        if (file.isEmpty()) {\n            return \"error\";\n        }\n        // 获取文件名\n        String fileName = file.getOriginalFilename();\n        // 获取文件的后缀名\n        String suffixName = fileName.substring(fileName.lastIndexOf(\".\"));\n        // 这里我使用随机字符串来重新命名图片\n        fileName = Calendar.getInstance().getTimeInMillis() + suffixName;\n\n        String realPath = request.getSession().getServletContext().getRealPath(\"images\");\n\n        String path = \"D:\\\\images\\\\\" + fileName;//此处保存在本地了，你也可以保存在图片服务器，或者realPath做临时文件\n        File dest = new File(path);\n        // 检测是否存在目录\n        if (!dest.getParentFile().exists()) {\n            dest.getParentFile().mkdirs();\n        }\n        try {\n            file.transferTo(dest);\n            String config = \"{\\\"state\\\": \\\"SUCCESS\\\",\" +\n                    \"\\\"url\\\": \\\"\" + \"http://localhost:8080/ueditor/images/\" + fileName + \"\\\",\" +\n                    \"\\\"title\\\": \\\"\" + fileName + \"\\\",\" +\n                    \"\\\"original\\\": \\\"\" + fileName + \"\\\"}\";\n            return config;\n        } catch (IllegalStateException e) {\n            e.printStackTrace();\n        } catch (IOException e) {\n            e.printStackTrace();\n        }\n        return \"error\";\n    }\n\n\n    /**\n     * 通过url请求返回图像的字节流\n     *      \n     */\n    @RequestMapping(\"/images/{fileName}\")\n    public void getIcon(@PathVariable(\"fileName\") String fileName, HttpServletRequest request, HttpServletResponse response) throws IOException {\n\n        if (StringUtils.isEmpty(fileName)) {\n            fileName = \"\";\n        }\n        String path = \"D:\\\\images\\\\\" + fileName;\n\n\n        File file = new File(path);\n        //判断文件是否存在如果不存在就返回默认图标\n        if (!(file.exists() && file.canRead())) {\n            file = new File(path);\n        }\n\n        FileInputStream inputStream = new FileInputStream(file);\n        byte[] data = new byte[(int) file.length()];\n        int length = inputStream.read(data);\n        inputStream.close();\n        response.setContentType(\"image/png\");\n        OutputStream stream = response.getOutputStream();\n        stream.write(data);\n        stream.flush();\n        stream.close();\n    }\n\n    @RequestMapping(value = \"/uploadContent.action\")\n    @ResponseBody\n    public void uploadContent(HttpServletRequest request) {\n        String content = request.getParameter(\"myContent\");\n        System.out.println(content);\n        return;\n    }\n}\n```\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n', null, null, null, null, null, '2019-03-05 21:27:08', '2019-03-05 21:27:08', '2019-03-05 21:27:08', null, null, null, '0');
INSERT INTO `article` VALUES ('29', 'Vue项目打包到springboot中', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 步骤\n打包步骤如下图：\n本文针对vue2.x的。\n1. 找到config/index.js配置文件\n\n![vue打包.png](https://upload-images.jianshu.io/upload_images/13150128-19734588ecdd4c2f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n2. 接着根目录运行\n```\nnpm run install\n```\n\n3.关于去掉访问地址的有个恶心的 #，可以参考这篇[文章](https://blog.csdn.net/lensgcx/article/details/78439514)\n\n**index.js完整配置如下：**\n\n```js\n\'use strict\'\n// Template version: 1.2.6\n// see http://vuejs-templates.github.io/webpack for documentation.\n\nconst path = require(\'path\')\n\nmodule.exports = {\n  dev: {\n    // Paths\n    assetsSubDirectory: \'static\',\n    assetsPublicPath: \'/\',\n    proxyTable: {\n      \'/api\': {\n        target: \'http://127.0.0.1:10000\',  //目标接口域名\n        changeOrigin: true,  //是否跨域\n        pathRewrite: {\n          \'^/api\': \'/\'   //重写接口\n        }\n      }\n    },\n\n    // Various Dev Server settings\n    host: \'localhost\', // can be overwritten by process.env.HOST\n    port: 9528, // can be overwritten by process.env.PORT, if port is in use, a free one will be determined\n    autoOpenBrowser: true,\n    errorOverlay: true,\n    notifyOnErrors: false,\n    poll: false, // https://webpack.js.org/configuration/dev-server/#devserver-watchoptions-\n\n    // Use Eslint Loader?\n    // If true, your code will be linted during bundling and\n    // linting errors and warnings will be shown in the console.\n    useEslint: true,\n    // If true, eslint errors and warnings will also be shown in the error overlay\n    // in the browser.\n    showEslintErrorsInOverlay: false,\n\n    /**\n     * Source Maps\n     */\n\n    // https://webpack.js.org/configuration/devtool/#development\n    devtool: \'cheap-source-map\',\n\n    // CSS Sourcemaps off by default because relative paths are \"buggy\"\n    // with this option, according to the CSS-Loader README\n    // (https://github.com/webpack/css-loader#sourcemaps)\n    // In our experience, they generally work as expected,\n    // just be aware of this issue when enabling this option.\n    cssSourceMap: false\n  },\n\n  build: {\n    // Template for index.html\n    index: path.resolve(__dirname, \'../../static/public/index.html\'),\n\n    // Paths\n    assetsRoot: path.resolve(__dirname, \'../../static/public\'),\n    assetsSubDirectory: \'static\',\n\n    /**\n     * You can set by youself according to actual condition\n     * You will need to set this if you plan to deploy your site under a sub path,\n     * for example GitHub pages. If you plan to deploy your site to https://foo.github.io/bar/,\n     * then assetsPublicPath should be set to \"/bar/\".\n     * In most cases please use \'/\' !!!\n     */\n    assetsPublicPath: \'/ritu-bd-official-tmc-manager/public/\',\n\n    /**\n     * Source Maps\n     */\n\n    productionSourceMap: false,\n    // https://webpack.js.org/configuration/devtool/#production\n    devtool: \'source-map\',\n\n    // Gzip off by default as many popular static hosts such as\n    // Surge or Netlify already gzip all static assets for you.\n    // Before setting to `true`, make sure to:\n    // npm install --save-dev compression-webpack-plugin\n    productionGzip: false,\n    productionGzipExtensions: [\'js\', \'css\'],\n\n    // Run the build command with an extra argument to\n    // View the bundle analyzer report after build finishes:\n    // `npm run build --report`\n    // Set to `true` or `false` to always turn it on or off\n    bundleAnalyzerReport: process.env.npm_config_report || false,\n\n    // `npm run build:prod --generate_report`\n    generateAnalyzerReport: process.env.npm_config_generate_report || false\n  }\n}\n\n```', null, null, null, null, null, '2019-03-05 21:27:29', '2019-03-05 21:27:29', '2019-03-05 21:27:29', null, null, null, '0');
INSERT INTO `article` VALUES ('30', 'Springboot整合Jersey', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 简介\n本文介绍的Jersey的客户端（请求工具）。它就类似于Httpclient这种工具类。原理什么的东西，你自己可以去**[官网](https://jersey.github.io/documentation/latest/user-guide.html#d0e4365)**看\n\n\n#### 使用\n* 导入maven依赖\n```xml\n<dependency>\n     <groupId>org.springframework.boot</groupId>\n    <artifactId>spring-boot-starter-jersey</artifactId>\n</dependency>\n```\n\n* 工具类实现\n```java\n\nimport java.util.Map;\n\nimport javax.ws.rs.client.Client;\nimport javax.ws.rs.client.ClientBuilder;\nimport javax.ws.rs.client.Entity;\nimport javax.ws.rs.client.WebTarget;\nimport javax.ws.rs.core.MediaType;\nimport javax.ws.rs.core.MultivaluedHashMap;\nimport javax.ws.rs.core.MultivaluedMap;\nimport javax.ws.rs.core.Response;\n\n\n/**\n * Jersey请求工具类\n * \n *\n */\npublic class JerseyClientUtil {\n\n	private static final int SUCCESS = 200;\n	private static final int TOKEN_INVALID = 401;\n	private static final String REQUEST_URL = \"http://www.baidu.com\";\n	/**\n	 * 带头部信息的get请求\n	 * \n	 * @param url\n	 * @param headers\n	 * @return\n	 */\n	public static String getWithHeader(String path, Map<String, Object> queryParam,\n			MultivaluedMap<String, Object> headers) {\n		String readEntity = null;\n		Client client = ClientBuilder.newClient();\n		WebTarget webTarget = client.target(REQUEST_URL).path(path);\n		for (Map.Entry<String, Object> entry : queryParam.entrySet()) {\n			webTarget.queryParam(entry.getKey(), entry.getValue());\n		}\n		Response response = webTarget.request().headers(headers).get();\n		readEntity = response.readEntity(String.class);\n		if (response.getStatus() == SUCCESS) {\n			return readEntity;\n		}\n		return null;\n	}\n\n	/**\n	 * 带头部信息的post请求\n	 * \n	 * @param url\n	 * @param headers\n	 * @param params\n	 * @return\n	 */\n	public static String postWithHeader(String path, MultivaluedMap<String, Object> headers, Map<String, String> params){\n		String readEntity = null;\n		Client client = ClientBuilder.newClient();\n		WebTarget target = client.target(REQUEST_URL).path(path);\n		Response response = target.request(MediaType.APPLICATION_JSON_TYPE).headers(headers)\n				.post(Entity.entity(params, MediaType.APPLICATION_JSON_TYPE));\n		readEntity = response.readEntity(String.class);\n		if (response.getStatus() == SUCCESS) {\n			return readEntity;\n		} \n		return null;\n\n	}\n	\n\n	/**\n	 * 带头部信息的delete请求\n	 * \n	 * @param url\n	 * @param headers\n	 * @return\n	 * @throws HXServerException\n	 */\n	public static String deleteWithHeader(String path, Map<String, Object> queryParam,\n			MultivaluedMap<String, Object> headers){\n		String readEntity = null;\n		Client client = ClientBuilder.newClient();\n		WebTarget webTarget = client.target(REQUEST_URL).path(path);\n		Response response = webTarget.request().headers(headers).delete();\n		readEntity = response.readEntity(String.class);\n		if (response.getStatus() == SUCCESS) {\n			return readEntity;\n		} \n		return null;\n	}\n	\n	\n	\n	\n	/**\n	 * 带头部信息的PUT请求\n	 * \n	 * @param url\n	 * @param headers\n	 * @return\n	 * @throws HXServerException\n	 */\n	public static String putWithHeader(String path, Map<String, Object> queryParam,\n			MultivaluedMap<String, Object> headers) {\n		\n		String readEntity = null;\n		Client client = ClientBuilder.newClient();\n		WebTarget webTarget = client.target(REQUEST_URL).path(path);\n		Response response = webTarget\n							.request(MediaType.APPLICATION_JSON_TYPE)\n							.headers(headers)\n							.put(Entity.entity(queryParam, MediaType.APPLICATION_JSON_TYPE));\n		readEntity = response.readEntity(String.class);\n		if (response.getStatus() == SUCCESS) {\n			return readEntity;\n		}\n		return null;\n		\n	}\n	\n}\n\n```', null, null, null, null, null, '2019-03-05 21:27:44', '2019-03-05 21:27:44', '2019-03-05 21:27:44', null, null, null, '0');
INSERT INTO `article` VALUES ('31', 'MyBatis总结', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 分页插件的使用\n1. pom.xml导入相关依赖\n\n```xml\n        <dependency>\n            <groupId>org.mybatis.spring.boot</groupId>\n            <artifactId>mybatis-spring-boot-starter</artifactId>\n            <version>1.3.1</version>\n        </dependency>\n\n        <dependency>\n            <groupId>mysql</groupId>\n            <artifactId>mysql-connector-java</artifactId>\n        </dependency>\n\n        <dependency>\n            <groupId>com.github.pagehelper</groupId>\n            <artifactId>pagehelper-spring-boot-starter</artifactId>\n            <version>1.2.5</version>\n        </dependency>\n```\n\n2. 使用方法\n\n```java\n    public PageBeanResult<ClientLog> getClientLogs(ClientLogVo clientInfo) {\n\n        try {\n             //1.设置分页\n            PageHelper.startPage(clientInfo.getPageNum(),clientInfo.getPageSize());\n             //2.正常的sql查询，它会自动的在后面加上相应的limit pagenum,pagesize.所以这里你写sql时，记得最后不要加分号。\n            List<ClientLog> list  = managerRepository.getClientLogs(clientInfo);\n           //3.返回的结果集进行封装。可以在PageInfo里找到页码，总数，pagenum，pagesize、结果集等信息\n            PageInfo<ClientLog> pageInfo = new PageInfo<>(list);\n            PageBeanResult<ClientLog> pageBeanResult = new PageBeanResult<>();\n            pageBeanResult.setPageNum(pageInfo.getPageNum());\n            pageBeanResult.setPageSize(pageInfo.getPageSize());\n            pageBeanResult.setTotalSize(pageInfo.getTotal());\n            pageBeanResult.setList(list);\n            return pageBeanResult;\n        } catch (Exception e) {\n            e.printStackTrace();\n        }\n        return null;\n    }\n```\n\n\n#### in语句的使用\n\n```java\n  @Select(\"<script>\"\n            + \"SELECT * FROM `user` WHERE id in \"\n            + \"<foreach item=\'item\' collection=\'list\' open=\'(\' close=\')\' separator=\',\'>\"\n            + \"#{item}\"\n            + \"</foreach>\"\n            + \"</script>\")\n    List<User> listUserByIds(List<Long> ids);\n\n```\n\n\n#### set标签和where标签\n\n```java\n  //使用set标签进行动态set，要注意条件判断：没被删除的用户才可以更新数据.最后一个逗号，它会自己处理的\n    @Update(\"<script>\"\n            + \"UPDATE `user` \"\n            + \"<set>\"\n            + \"<if test=\'nickName != null\'>nick_name = #{nickName}, </if>\"\n            + \"<if test=\'age != null\'>age = #{age}, </if>\"\n            + \"<if test=\'phoneNumber != null\'>phone_number = #{phoneNumber}, </if>\"\n            + \"<if test=\'birthday != null\'>birthday = #{birthday}, </if>\"\n            + \"<if test=\'status != null\'>status = #{status}, </if>\"\n            + \"<if test=\'sex != null\'>sex = #{sex}, </if>\"\n            + \"</set>\"\n            + \"WHERE id = #{id} AND status != \'DELETE\';\"\n            + \"</script>\")\n    void updateUser(User user);\n```\n\n\n#### 大于号和小于号等字符的处理\n\n```\n原符号       <        <=      >       >=       &        \'        \"\n替换符号    &lt;    &lt;=   &gt;    &gt;=   &amp;   &apos;  &quot;\n例如：sql如下：\ncreate_date_time &gt;= #{startTime} and  create_date_time &lt;= #{endTime}\n```\n或者\n\n```\n大于等于\n<![CDATA[ >= ]]>\n小于等于\n<![CDATA[ <= ]]>\n例如：sql如下：\ncreate_date_time <![CDATA[ >= ]]> #{startTime} and  create_date_time <![CDATA[ <= ]]> #{endTime}\n```\n\n#### 设置mybatis日志打印\n在配置文件中加入如下配置\n```yml\nlogging:\n  level:\n    #Mapper所在的包\n    com.zero.repository: debug\n```\n\n\n\n\n\n\n', null, null, null, null, null, '2019-03-05 21:28:06', '2019-03-05 21:28:06', '2019-03-05 21:28:06', null, null, null, '0');
INSERT INTO `article` VALUES ('32', 'SpringAOP', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, 'springAOP切面拦截参数进行校验。\n```\n@Component\n@Aspect\npublic class ApiAspect {\n\n	/**\n	 * @Order 指优先级\n	 * 		注意点：controller中的方法的第一个参数必须是ak，不然无法起到相应的作用。\n	 * @param joinPoint\n	 * @param ak\n	 * @return\n	 * @throws Throwable\n	 */\n	@Order(5)\n	@Around(\"execution(public * com.ritu.poi.api.*.*(..)) && args(ak,..)\")\n	public Object validateAkAround(ProceedingJoinPoint joinPoint, String ak) throws Throwable {\n		if (StringUtils.isBlank(ak)) {\n			return JsonMapper.nonDefaultMapper().toJson(ResponseResult.ofError(\"ak不能为空\", null));\n		} else {\n			return joinPoint.proceed();\n		}\n	}\n}\n\n```', null, null, null, null, null, '2019-03-05 21:28:24', '2019-03-05 21:28:24', '2019-03-05 21:28:24', null, null, null, '0');
INSERT INTO `article` VALUES ('33', 'Mysql问题集锦', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '####  问题一：匿名登录占用，Mariadb 数据库root用户无法登录\n\n**[ ERROR 1045 (28000): Access denied for user \'root\'@\'localhost\' (using password: YES)]**\n\n如果你的Linux控制台是匿名登录的话（也就是说运行 mysql -uroot -pxxxxx  无法登录到mysql的话）\n\n**解决方法：**\n打开Navicat，运行下面的指令\n```sql\ngrant all privileges on *.* to root@localhost identified by \'xxxxxx\';\n```\n**原因：**\n匿名登录占用了。【[参考文章](https://blog.csdn.net/u012501054/article/details/74990591)】\n\n\n\n####  问题二：解决mysql查询，in条件参数为带逗号的字符串，查询结果错误。\n\n**场景如下：（in语句中如果是一段字符串的话）。**\n\n![IN语句字符串.png](https://upload-images.jianshu.io/upload_images/13150128-b0976201e235f1d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n**解决方法：使用FIND_IN_SET函数**\n\n```\nSELECT pt.`code`,pt.`name` FROM `poi_type` pt WHERE FIND_IN_SET(pt.`code`,\'2106,2103,2104\');\n```\n效果如下图：\n\n![FIND_IN_SET.png](https://upload-images.jianshu.io/upload_images/13150128-4932b3c2bf3907f1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n**注意事项：**\n\nFIND_IN_SET是**全表查询**，而IN是**部分表查询**的（可以使用索引的）。\n【参考】[Mysql中FIND_IN_SET()和IN区别简析。](https://www.jb51.net/article/125744.htm)\n', null, null, null, null, null, '2019-03-05 21:28:42', '2019-03-05 21:28:42', '2019-03-05 21:28:42', null, null, null, '0');
INSERT INTO `article` VALUES ('34', 'Vue+axios', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '####  简介\naxios基于 [Promise](https://www.cnblogs.com/whybxy/p/7645578.html) 的 HTTP 请求客户端，可同时在浏览器和 node.js 中使用.详情可以参考**[官网](https://github.com/axios/axios)**。\n\n\n####  常规使用\n\n**request.js**\n\n```\nimport axios from \'axios\'\n// import store from \'@/store\'\n\n// 创建axios实例\nconst service = axios.create({\n    baseURL: \'\',\n    timeout: 15000 // 请求超时时间\n})\n\n\n// http request 请求拦截器，有token值则配置上token值\n// service.interceptors.request.use(\n//     config => {\n//         if (token) {  // 每次发送请求之前判断是否存在token，如果存在，则统一在http请求的header都加上token，不用每次请求都手动添加了\n//             config.headers.Authorization = token;\n//         }\n//         return config;\n//     },\n//     err => {\n//         return Promise.reject(err);\n// });\n\nservice.interceptors.response.use(\n    function (response) {\n        //请求正常则返回\n        return Promise.resolve(response)\n    },\n    function (error) {\n        // 请求错误则向store commit这个状态变化\n        // const httpError = {\n        //     hasError: true,\n        //     status: error.response.status,\n        //     statusText: error.response.statusText\n        // }\n        // store.commit(\'ON_HTTP_ERROR\', httpError)\n        return Promise.reject(error)\n    }\n)\n\nexport default service\n\n```\n\n**新建一个api目录下login.js**\n\n```\nimport request from \'@/utils/request\'\n\nexport function getTest(params) {\n    return request({\n        url: \'/u/register\',\n        method: \'get\',\n        params\n    })\n}\n```\n\n**在登录组件login.vue中调用**\n\n```\nimport { getTest } from \"@/api/login\";\n\n\n methods: {\n    handleLogin() {\n      getTest(this.userame).then(response => {\n           alert(response.data);\n           this.$store.dispatch(\'increment\')\n      })\n    }\n  }\n```\n\n\n####  一些坑\n**跨域问题、post表单提交问题**  ==> 推荐这位大哥[总结](https://blog.csdn.net/qq_36575992/article/details/80338538)得还是不错的。\n\n\n\n\n\n\n\n\n\n\n\n\n\n', null, null, null, null, null, '2019-03-05 21:28:55', '2019-03-05 21:28:55', '2019-03-05 21:28:55', null, null, null, '0');
INSERT INTO `article` VALUES ('35', 'VueRouter总结', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '####  简介\n**Vue Router 是 [Vue.js](http://cn.vuejs.org/) 官方的路由管理器。它和 Vue.js 的核心深度集成，让构建单页面应用变得易如反掌。详情去看[官网](https://router.vuejs.org/zh/)**\n\n\n####  基本概念\n* 1. 在**【HTML】**中使用\n\n```\n    <!-- 使用 router-link 组件来导航. -->\n    <!-- 通过传入 `to` 属性指定链接. -->\n    <!-- <router-link> 默认会被渲染成一个 `<a>` 标签 -->\n    <router-link to=\"/foo\">Go to Foo</router-link>\n```\n\n* 2. 在**【组件】**中使用\n\n```\n// Home.vue\nexport default {\n  computed: {\n    username () {\n      // 我们很快就会看到 `params` 是什么\n      return this.$route.params.username\n    }\n  },\n  methods: {\n    goBack () {\n      window.history.length > 1\n        ? this.$router.go(-1)\n        : this.$router.push(\'/\')\n    }\n  }\n}\n```\n\n* 3. **【动态路由】** \n如果你想在路由上带参数，比如 /user/001 这种操作，可以参考 [动态路由配置](https://router.vuejs.org/zh/guide/essentials/dynamic-matching.html#%E5%93%8D%E5%BA%94%E8%B7%AF%E7%94%B1%E5%8F%82%E6%95%B0%E7%9A%84%E5%8F%98%E5%8C%96)\n\n\n* 3. **【编程式导航】** \n如果你想在js代码中实现跳转可以考虑使用[编程式导航](https://router.vuejs.org/zh/guide/essentials/navigation.html) \n\n* 4. **【响应路由】** \n例如：路径1：/user/001； 路径2：/user/002 。根据路由的不同复用原来的组件实例。这样子可以参考[响应路由](https://router.vuejs.org/zh/guide/essentials/dynamic-matching.html#%E5%93%8D%E5%BA%94%E8%B7%AF%E7%94%B1%E5%8F%82%E6%95%B0%E7%9A%84%E5%8F%98%E5%8C%96) \n\n* 5. **【重定向路由】** \n[路由重定向](https://router.vuejs.org/zh/guide/essentials/redirect-and-alias.html#%E9%87%8D%E5%AE%9A%E5%90%91)\n\n**其他用法还是去[官网](https://router.vuejs.org/zh/)自己看呗。**\n\n####  常规用法\n* 1.在根目录新建一个router的文件夹，写一个**index.js**文件，内容如下\n\n```\nimport Vue from \'vue\'\nimport Router from \'vue-router\'\n// 0、加载相关依赖包\nVue.use(Router)\n// 1、引入组件\nimport Layout from \'@/views/layout/Layout\'\n// 2、定义路由\nexport const constantRouterMap = [\n    {\n      path: \'/\',\n      component: Layout,\n      children: [\n        {\n          path: \'/\',\n          component: () => import(\'@/views/login/index\')\n        }\n      ]\n    }\n]\n// 3、创建\nexport default new Router({\n    // mode: \'history\', // require service support\n    scrollBehavior: () => ({ y: 0 }),\n    routes: constantRouterMap\n  })\n```\n\n* 2.在根目录中找到**main.js**，配置如下：\n\n```\nimport Vue from \'vue\'\nimport App from \'./App.vue\'\nimport router from \'./router\'   //这里指向的是第一步中的index.js\nimport store from \'./store\'\n\nVue.config.productionTip = false\n\nnew Vue({\n  router, // 挂载到根实例\n  store,\n  render: h => h(App),\n}).$mount(\'#app\')\n\n```\n\n* 3.在根目录中找到App.vue，配置**<router-view/>**标签添加如下：\n\n```\n<template>\n  <div id=\"app\">\n    <router-view/>\n  </div>\n</template>\n\n<script>\n\n\nexport default {\n  name: \'app\'\n}\n</script>\n\n```\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n', null, null, null, null, null, '2019-03-05 21:29:06', '2019-03-05 21:29:06', '2019-03-05 21:29:06', null, null, null, '0');
INSERT INTO `article` VALUES ('36', '线程停止总结', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, '#### 1 单线程停止\n```\npublic class ThreadStopSafeInterrupted {\n	public static void main(String[] args) throws InterruptedException {\n		Thread thread = new Thread() {\n			@Override\n			public void run() {\n				while (true) {\n					// 使用中断机制，来终止线程\n					if (Thread.currentThread().isInterrupted()) {\n						System.out.println(\"Interrupted ...\");\n						break;\n					}\n \n					try {\n						Thread.sleep(3000);\n					} catch (InterruptedException e) {\n						System.out.println(\"Interrupted When Sleep ...\");\n						// Thread.sleep()方法由于中断抛出异常。\n						// Java虚拟机会先将该线程的中断标识位清除，然后抛出InterruptedException，\n						// 因为在发生InterruptedException异常的时候，会清除中断标记\n						// 如果不加处理，那么下一次循环开始的时候，就无法捕获这个异常。\n						// 故在异常处理中，再次设置中断标记位\n						Thread.currentThread().interrupt();\n					}\n \n				}\n			}\n		};\n \n		// 开启线程\n		thread.start();\n		Thread.sleep(2000);\n		thread.interrupt();//主线程发起中断\n \n	}\n \n}\n```\n\n\n#### 2 线程池停止\n\n```\n   /**\n     * 停止线程池中的所有线程\n     */\n    private void stopDownloadThreadTask() {\n        try {\n            this.fixedThreadPool.shutdown();//尝试停止所有线程\n            if(!this.fixedThreadPool.awaitTermination(5 * 1000, TimeUnit.MILLISECONDS)){\n                this.fixedThreadPool.shutdownNow();//规定时间内还未停止，再次请求停止\n            }\n        } catch (InterruptedException e) {\n            logger.error(\"awaitTermination interrupted: \" + e);\n            this.fixedThreadPool.shutdownNow();//停不了就再停止一次。\n        }\n\n    }\n```\n\n\n\n\n\n\n\n\n\n\n\n', null, null, null, null, null, '2019-03-05 21:29:18', '2019-03-05 21:29:18', '2019-03-05 21:29:18', null, null, null, '0');
INSERT INTO `article` VALUES ('37', 'Vuex总结', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', '共享的状态管理器，比如你想修改某些背景色，设备状态、cookie等信息的时候你可以考虑用它。', '####  简介\n**简单来讲：共享的状态管理器，比如你想修改某些背景色，设备状态、cookie等信息的时候你可以考虑用它。其他的当跨页面共享数据的时候也可以考虑用它。其他的自己去看[官网](https://vuex.vuejs.org/zh/)、所有的[API参考]( https://vuex.vuejs.org/zh/api/)**\n\n####  State单一状态树\n用来存储数据的，相当于一个变量（支持json对象、数组、字符串等），相当于数据源。\n\n**获取state中的状态值可以通过直接找或者通过getter方式**\n\n```\n//方式一\nthis.$store.state.test.phone.name\n\n//方式二\nthis.$store.getters.phone\n```\n\n####  Getter\n有时候我们需要从 store 中的 state 中派生出一些状态，例如对列表进行过滤并计数。\nVuex 允许我们在 store 中定义“getter”（可以认为是 store 的计算属性）。就像计算属性一样，getter 的返回值会根据它的依赖被缓存起来，且只有当它的依赖值发生了改变才会被重新计算。\n\n\n**Getter可以在组件的computed的时候通过get方法进行获取。以及触发Mutation中的方法进行修改。**\n```\n  computed: {\n    company: {\n      get() {\n        return this.$store.state.test.company;\n      },\n      set(value) {\n        this.$store.commit(\"CHANGE_COMPANY\", value);\n      }\n    }\n```\n\n#### Mutation\n更改 Vuex 的 store 中的状态的唯一方法是提交 mutation。它是**同步**的。\n\n**在页面可以直接用commit的方式触发其中的方法。**\n```\nthis.$store.commit(\"CHANGE_COMPANY\", value);\n```\n\n####  Action\n\nAction 类似于 mutation，不同在于：\n* Action 提交的是 mutation，而不是直接变更状态。\n* Action 可以包含任意异步操作。\n\n**Action可以通过dispatch来触发。**\n```\n   this.$store.dispatch(\'toggleDevice\',this.company)\n```\n\n\n####  所有整合\n\n**主配置index.js**\n```\nimport Vue from \'vue\'\nimport Vuex from \'vuex\'\nimport app from \'./modules/app\'\nimport test from \'./modules/test\'\nimport getters from \'./getters\'\n\nVue.use(Vuex)\n\nexport default new Vuex.Store({\n    modules: {\n        test\n    },\n    getters\n  })\n```\n\n\n**store中的某个模块 test.js**\n```\nconst test = {\n    state: {\n        phone: {\n            name: \'xiaomi\',\n            price: 3000\n        },\n        company: \'xm\'\n    },\n    mutations: {\n        CHANGE_PHONE: (state, device) => {\n            console.log(\"CHANGE_PHONE = device:\"+device)\n            if (device == \'hw\') {\n                state.phone.price = state.phone.price + 1000\n                state.phone.name = \'huawei\'\n                state.phone.company == \'hw\'\n            } else {\n                state.phone.price = state.phone.price - 1000\n                state.phone.name = \'xiaomi\'\n                state.phone.company == \'xm\'\n            }\n            \n        },\n        CHANGE_COMPANY: (state, device) => {\n            console.log(\"CHANGE_COMPANY = device:\"+device)\n            state.phone.company == device\n          \n            \n        },\n    },\n    actions: {\n        toggleDevice({ commit }, device) {\n            console.log(\"device:\"+device)\n            commit(\'CHANGE_PHONE\', device)\n        },\n        toggleCompany({ commit }, device) {\n            console.log(\"device:\"+device)\n            commit(\'CHANGE_COMPANY\', device)\n        }\n\n    }\n}\n\nexport default test\n\n```\n\n\n**getter.js**\n\n```\nconst getters = {\n    phone: state => state.test.phone\n  }\n  export default getters\n  \n```\n\n\n\n**页面模板调用index.vue**\n```\n<template>\n  <div>\n    这是一个layout{{userame}}\n    <input v-model=\"company\">\n    <a @click=\"handleLogin\">点击我</a>\n  </div>\n</template>\n\n<script>\nimport { getTest } from \"@/api/login\";\n\nexport default {\n  name: \"Layout\",\n  data() {\n    return {\n      userame: this.$store.state.test.phone.name\n    };\n  },\n  computed: {\n    company: {\n      get() {\n        return this.$store.state.test.company;\n      },\n      set(value) {\n        this.$store.commit(\"CHANGE_COMPANY\", value);\n      }\n    }\n  },\n  methods: {\n    handleLogin() {\n      console.log(\"xxxxxxxxxxxxxxxx==\"+this.company);\n      console.log(this.$store.getters.phone);\n    //   this.$store.commit(\"CHANGE_PHONE\", this.$store.state.test.company);\n      this.$store.dispatch(\'toggleDevice\',this.company)\n      console.log(this.$store.getters.phone);\n      // getTest(this.userame).then(response => {\n      //     alert(response.data);\n      //      this.$store.dispatch(\'increment\')\n      // })\n    }\n  }\n};\n</script>\n\n```\n\n\n####  其他知识\n* 1. 项目的结构：https://vuex.vuejs.org/zh/guide/structure.html\n* 2. 表单的处理，关于store与表单元素双向绑定的实现：https://vuex.vuejs.org/zh/guide/forms.html\n* 3. 严格模式：https://vuex.vuejs.org/zh/guide/strict.html\n\n', null, '2', null, '9', '9', '2019-03-05 21:29:31', '2019-03-05 23:38:00', '2019-03-05 23:38:00', null, null, null, '0');
INSERT INTO `article` VALUES ('38', 'Netty实现websocket聊天', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', 'Netty实现websocket聊天', '#####  简介\n本文主要参考[视频教程](https://coding.imooc.com/class/261.html)，然后自己总结一下而已。\n\n![总体流程.png](https://upload-images.jianshu.io/upload_images/13150128-bd3c823e1ab4b033.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n#### 启动类\n主要是配置主线程组和从线程组、绑定端口等基本启动netty服务的操作。\n\n```\n\n@Component\npublic class WebSocketServer {\n\n\n    private EventLoopGroup mainGroup;\n    private EventLoopGroup subGroup;\n    private ServerBootstrap server;\n    private ChannelFuture channelFuture;\n\n    private static class  SingletionWSServer {\n        static final WebSocketServer instance = new WebSocketServer();\n    }\n\n    public static WebSocketServer getInstance() {\n        return SingletionWSServer.instance;\n    }\n\n\n    public WebSocketServer() {\n        mainGroup = new NioEventLoopGroup();\n        subGroup = new NioEventLoopGroup();\n        server = new ServerBootstrap();\n        server.group(mainGroup,subGroup)\n                .channel(NioServerSocketChannel.class)\n                .childHandler(new WebSocketInitialzer());\n    }\n\n\n    public void start() {\n        this.channelFuture = server.bind(8088);\n        System.err.println(\"【Netty Server 启动成功】\");\n\n    }\n}\n```\n\n#### 初始化配置类\n主要配置http相关的处理类、大数据流的支持、对httpMessage进行聚合、心跳检测、websocket相关的处理类、自定义消息处理类。\n\n```\n\npublic class WebSocketInitialzer extends ChannelInitializer<SocketChannel> {\n\n\n    @Override\n    protected void initChannel(SocketChannel ch) throws Exception {\n\n        ChannelPipeline pipeline = ch.pipeline();\n\n        //======================== http相关=============================\n        //websocket基于http协议，所以需要HttpServerCodec\n        pipeline.addLast(\"HttpServerCodec\",new HttpServerCodec());\n\n        //对写大数据流的支持\n        pipeline.addLast(new ChunkedWriteHandler());\n\n        //对httpMessage进行聚合，聚合成AggregatedFullHttpRequest和AggregatedFullHttpResponse\n        pipeline.addLast(new HttpObjectAggregator(1024 * 64));\n\n\n        // ====================== 增加心跳支持 start    ======================\n        // 针对客户端，如果在1分钟时没有向服务端发送读写心跳(ALL)，则主动断开\n        // 如果是读空闲或者写空闲，不处理\n        pipeline.addLast(new IdleStateHandler(8, 10, 12));\n        // 自定义的空闲状态检测\n        pipeline.addLast(new HeartBeatHandler());\n        // ====================== 增加心跳支持 end    ======================\n\n\n        //======================== websocket相关=============================\n\n        //websocket服务器处理的协议，用于指定给客户端连接访问的路由：\"/ws\"\n        //本handler会帮你处理一些繁重的复杂的事。会帮你处理握手动作: handshaking\n        //对于websocket来讲，都是以frames进行传输的，不同的数据类型对应的frames也不同。\n        pipeline.addLast(new WebSocketServerProtocolHandler(\"/ws\"));\n\n\n        //自定义的handler\n        pipeline.addLast(new ChatHandler());\n\n    }\n}\n```\n\n\n\n#### 处理消息的handler\n主要是对消息传递、channel的操作、心跳处理逻辑都集中在这里处理。\n\n```\n\n/**\n * 处理消息的handler\n * TextWebSocketFrame：在netty中，是用于websocket专门处理文本的对象，frame是消息的载体。\n */\npublic class ChatHandler extends SimpleChannelInboundHandler<TextWebSocketFrame> {\n\n    //获取到所有的客户端channel。\n    public static ChannelGroup users = new DefaultChannelGroup(GlobalEventExecutor.INSTANCE);\n\n    @Override\n    protected void channelRead0(ChannelHandlerContext ctx, TextWebSocketFrame msg) throws Exception {\n\n        //1.获取客户端发来的消息\n        String content = msg.text();\n\n        Channel currentChannel = ctx.channel();\n\n        //2.判断消息类型，根据不同的类型来处理不同的业务\n        DataContent dataContent = JSONObject.parseObject(content, DataContent.class);\n        Integer action = dataContent.getAction();\n\n        if (action == NettyConst.CONNECT){\n            //  2.1 当websocket，第一次open的时候，初始化channel，把用的channel和userid关联起来\n            String senderId = dataContent.getChatMsg().getSenderId();\n            UserChannelRel.put(senderId,currentChannel);\n\n        }else if (action == NettyConst.CHAT) {\n            //  2.2 聊天类型的消息，把聊天记录保存到数据库中，同时标记消息的签收状态【未签收】\n            ChatMsg chatMsg = dataContent.getChatMsg();\n            String msgMsg = chatMsg.getMsg();\n            String receiverId = chatMsg.getReceiverId();\n            String senderId = chatMsg.getSenderId();\n\n            //保存消息到数据库，并且标记为未签收。\n            UserService userService = (UserService)SpringUtil.getBean(\"userService\");\n            String msgId = userService.saveMsg(chatMsg);\n            chatMsg.setMsgId(msgId);\n\n            //发送消息\n            //从全局用户channel关系中获取接收方的channel\n            Channel receiverChannel = UserChannelRel.get(receiverId);\n            if (receiverChannel == null) {\n                //TODO 推送消息\n\n            }else {\n                //当receiverChannel不为空是，从channelGroup中查找对应的channel是否存在\n                Channel findChannel = users.find(receiverChannel.id());\n                    if (findChannel != null) {\n                        //用户在线\n                        receiverChannel.writeAndFlush(\n                                new TextWebSocketFrame(\n                                        JSONObject.toJSONString(chatMsg)));\n                    }else {\n                        //用户离线\n\n                    }\n\n            }\n\n        }else  if (action == NettyConst.SIGNED) {\n            //  2.3 签收消息类型，针对具体的消息进行签收，修改数据库中对应的消息签收状态【已签收】\n            UserService userService = (UserService)SpringUtil.getBean(\"userService\");\n            //扩展字段在signed类型的消息中，代表需要去签收的消息id，逗号分隔\n            String msgIdsStr = dataContent.getExtand();\n            String[] msgIds = msgIdsStr.split(\",\");\n\n            List<String> msgIdList = new ArrayList<>();\n            for (String mid : msgIdList) {\n                if (StringUtils.isNotBlank(mid)){\n                    msgIdList.add(mid);\n                }\n            }\n            System.out.println(msgIdList.toString());\n\n            if (msgIdList != null && !msgIdList.isEmpty() && msgIdList.size() >0) {\n                //批量签收\n                userService.updateMsgSigned(msgIdList);\n            }\n\n        }else if (action == NettyConst.KEEPALIVE){\n            //  2.4 心跳类型的消息\n            System.out.println(\"收到来自channel为[\" + currentChannel + \"]的心跳包...\");\n        }\n\n    }\n\n\n    /**\n     * 当客户端连接服务端之后（打开连接）\n     * 获取客户端的channel，并且放到ChannelGroup中去进行管理\n     * @param ctx\n     * @throws Exception\n     */\n    @Override\n    public void handlerAdded(ChannelHandlerContext ctx) throws Exception {\n        users.add(ctx.channel());\n    }\n\n    @Override\n    public void handlerRemoved(ChannelHandlerContext ctx) throws Exception {\n        //当触发handler销毁时，这个会自动的移除的。\n        users.remove(ctx.channel());\n\n    }\n\n\n    @Override\n    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) throws Exception {\n        cause.printStackTrace();\n        //发生异常之后关闭连接，随后从ChannelGroup中移除\n        ctx.channel().close();\n        users.remove(ctx.channel());\n    }\n}\n\n```\n\n\n\n#### 心跳处理handler\n```\npublic class HeartBeatHandler extends ChannelInboundHandlerAdapter {\n\n    @Override\n    public void userEventTriggered(ChannelHandlerContext ctx, Object evt) throws Exception {\n\n        // 判断evt是否是IdleStateEvent（用于触发用户事件，包含 读空闲/写空闲/读写空闲 ）\n        if (evt instanceof IdleStateEvent) {\n            IdleStateEvent event = (IdleStateEvent)evt;		// 强制类型转换\n\n            if (event.state() == IdleState.READER_IDLE) {\n                System.out.println(\"进入读空闲...\");\n            } else if (event.state() == IdleState.WRITER_IDLE) {\n                System.out.println(\"进入写空闲...\");\n            } else if (event.state() == IdleState.ALL_IDLE) {\n\n                System.out.println(\"channel关闭前，users的数量为：\" + ChatHandler.users.size());\n\n                Channel channel = ctx.channel();\n                // 关闭无用的channel，以防资源浪费\n                channel.close();\n\n                System.out.println(\"channel关闭后，users的数量为：\" + ChatHandler.users.size());\n            }\n        }\n\n    }\n\n}\n```\n\n\n#### 聊天实体类DataContent \n\n```\n@Data\npublic class DataContent implements Serializable{\n\n    private static final long serialVersionUID = 1L;\n\n    private Integer action;     //动作类型\n    private ChatMsg chatMsg;    //用户的聊天内容entity\n    private String extand;      //扩展字段\n\n\n}\n\n```\n\n\n\n#### 页面中的调用websocket服务\n\n```\n<!DOCTYPE html>\n<html>\n	<head>\n		<meta charset=\"utf-8\" />\n		<title></title>\n	</head>\n	<body>\n		<div>发送消息</div>\n		<input type=\"text\" id=\"msgContent\" />\n		<input type=\"button\" value=\"点我发送\" onclick=\"CHAT.chat()\" />\n		\n		<div>接收消息：</div>\n		<div id=\"receiveMsg\" style=\"background: gray;\"></div>\n		\n		\n		<script type=\"application/javascript\">\n			window.CHAT = {\n				socket: null,\n				init: function() {\n					if (window.WebSocket){\n						CHAT.socket = new WebSocket(\"ws://192.168.11.138:8088/ws\");\n						\n						CHAT.socket.onopen = function() {\n							console.log(\"onopen连接成功。。。\");\n						},\n						CHAT.socket.onclose = function() {\n							console.log(\"onclose连接关闭。。。\");\n\n						},\n						CHAT.socket.onerror = function() {\n							console.log(\"onerror发生异常。。。\");\n\n						},\n						CHAT.socket.onmessage = function(e) {\n							console.log(\"onmessage接收到消息:\"+e.data);\n							var receiveMsg = document.getElementById(\"receiveMsg\");\n							var html = receiveMsg.innerHTML;\n							receiveMsg.innerHTML = html+\"<br>\" + e.data;\n						}\n						\n					}else{\n						alert(\"浏览器不支持websocket协议.....\");\n					}\n				},\n				chat: function() {\n					var msg = document.getElementById(\"msgContent\");\n					CHAT.socket.send(msg.value);\n				}\n			}\n			\n			CHAT.init();\n		</script>\n		\n	</body>\n</html>\n\n```\n\n\n####', null, '0', null, '9', '8', '2019-03-05 21:29:44', '2019-03-21 22:17:11', '2019-03-21 22:17:11', null, null, null, '0');
INSERT INTO `article` VALUES ('39', 'Vue基础(一)', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', '路由在Vue全家桶里面定位是什么呢，创建单页应用！简单！我们知道Vuejs是一系列的组件组成应用，既然是组件那么就需要组合起来，将组件(components)映射到路由(routes)，然后告诉 vue-router 在哪里渲染它们！', '#### Vue-router\nVue的路由，先献上文档（[https://router.vuejs.org/zh-cn/](https://router.vuejs.org/zh-cn/)）\n\n路由在Vue全家桶里面定位是什么呢，创建单页应用！简单！我们知道Vuejs是一系列的组件组成应用，既然是组件那么就需要组合起来，将组件(components)映射到路由(routes)，然后告诉 vue-router 在哪里渲染它们！\n\n参考配置：\n```\nimport Vue from \'vue\'\nimport Router from \'vue-router\'\n\nVue.use(Router)\n\nimport Layout from \'@/views/layout/Layout\'\n\nexport const constantRouterMap = [\n    {\n      path: \'/\',\n      component: Layout,\n      children: [\n        {\n          path: \'/\',\n          component: () => import(\'@/views/login/index\')\n        }\n      ]\n    }\n]\n\nexport default new Router({\n    // mode: \'history\', // require service support\n    scrollBehavior: () => ({ y: 0 }),\n    routes: constantRouterMap\n  })\n```\n\n\n#### Vuex\n\n献上文档（[https://vuex.vuejs.org/zh-cn/](https://vuex.vuejs.org/zh-cn/)）\n\nVuex 是一个专为 Vue.js 应用程序开发的状态管理模式。什么是状态管理？可以简单理解为管理数据流，多页面共享一个data库（全局）。\n\n参考配置：\ntest.js\n```\nconst test = {\n    state: {\n        mytest: \'12312312313\'\n    }\n}\n\nexport default test\n``` \n\nindex.js\n```\nimport Vue from \'vue\'\nimport Vuex from \'vuex\'\nimport app from \'./modules/app\'\nimport test from \'./modules/test\'\nimport getters from \'./getters\'\n\nVue.use(Vuex)\n\nexport default new Vuex.Store({\n    modules: {\n        app,\n        test\n    },\n    getters\n  })\n```\n\n在组件调用\n```\n<template>\n    <div>\n        这是一个layout{{userame}}\n        <a @click=\"handleLogin\">点击我</a>\n    </div>\n</template>\n\n<script>\nimport { getTest } from \'@/api/login\'\n\nexport default {\n    name: \'Layout\',\n    data() {\n        return {\n            userame: this.$store.state.test.mytest \n        }\n    },\n    computed: {\n        count () {\n            return this.$store.state.test.mytest \n        }\n    },\n    methods: {\n        handleLogin() {\n            getTest(this.userame).then(response => {\n                alert(response.data);\n            })\n        }\n    }\n}\n</script>\n```\n\n#### axios\n\n封装的ajax,可以根据自己的项目情况再进行封装，然后action中调用。具体可以参考[https://github.com/mzabriskie/axios](https://github.com/mzabriskie/axios)\n\n参考配置：\n**封装 request.js请求工具**\n```\nimport axios from \'axios\'\n// import store from \'@/store\'\n\n// 创建axios实例\nconst service = axios.create({\n    baseURL: \'\',\n    timeout: 15000 // 请求超时时间\n})\n\nservice.interceptors.response.use(\n    function (response) {\n        //请求正常则返回\n        return Promise.resolve(response)\n    },\n    function (error) {\n        // 请求错误则向store commit这个状态变化\n        // const httpError = {\n        //     hasError: true,\n        //     status: error.response.status,\n        //     statusText: error.response.statusText\n        // }\n        // store.commit(\'ON_HTTP_ERROR\', httpError)\n        return Promise.reject(error)\n    }\n)\nexport default service\n```\n**自定义的api请求login.js**\n```\nimport request from \'@/utils/request\'\n\nexport function getTest(params) {\n    return request({\n        url: \'/u/register\',\n        method: \'get\',\n        params\n    })\n}\n```\n\n**在组件中调用**\n```\n  <template>\n    <div>\n        这是一个layout{{userame}}\n        <a @click=\"handleLogin\">点击我</a>\n    </div>\n</template>\n\n<script>\nimport { getTest } from \'@/api/login\'\n\nexport default {\n    name: \'Layout\',\n    data() {\n        return {\n            userame: this.$store.state.test.mytest \n        }\n    },\n    computed: {\n        count () {\n            return this.$store.state.test.mytest \n        }\n    },\n    methods: {\n        handleLogin() {\n            getTest(this.userame).then(response => {\n                alert(response.data);\n            })\n        }\n    }\n}\n</script>\n```\n\n\n\n#### 总结\n\n参考GitHub 整合[源码](https://github.com/xbmchina/vue-home-template)\n\n\n\n\n\n\n', null, '0', null, '9', '12', '2019-03-05 21:29:56', '2019-03-05 23:40:16', '2019-03-05 23:40:16', null, null, null, '0');
INSERT INTO `article` VALUES ('40', 'FastFDS安装教程', null, 'zero', null, 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', 'FastDFS是一个开源的轻量级分布式文件系统,由跟踪服务器(tracker server)、存储服务器(storage server)和客户端(client)三个部分组成,主要解决了海量数据存储问题,特别适合以中小文件(建议范围:4KB < file_size <500MB)为载体的在线服务。', '#### 简介\nFastDFS是一个开源的轻量级分布式文件系统,由跟踪服务器(tracker server)、存储服务器(storage server)和客户端(client)三个部分组成,主要解决了海量数据存储问题,特别适合以中小文件(建议范围:4KB < file_size <500MB)为载体的在线服务。\n\n**本文基于阿里云centos7.2**\n\n#### 准备工作\n* 1.余大的GitHub: https://github.com/happyfish100 中的[fastdfs](https://github.com/happyfish100/fastdfs)、[libfastcommon](https://github.com/happyfish100/libfastcommon)、\n[fastdfs-nginx-module](https://github.com/happyfish100/fastdfs-nginx-module)  这三个需要下载。\n* 2.下载Nginx。链接地址 http://nginx.org/en/download.html\n\n\n### 开始安装\n#### FastFDS安装\n* 1、安装工具\n```\nyum -y install unzip zip\nyum -y install gcc-c++\nyum -y install pcre pcre-devel \nyum -y install zlib zlib-devel \nyum -y install openssl openssl-devel\n```\n* 2、上传fastfds、libfastcommon、fastdfs-nginx-module到/usr/local/  目录下并解压\n```\nunzip libfastcommon-master.zip\nunzip fastdfs-nginx-module-master.zip\ntar -zxvf fastdfs-5.11.tar.gz\ntar -zxvf nginx-1.14.1.tar.gz\n```\n\n* 3、安装libfastcommon\n进入libfastcommon目录，运行\n```\n./make\n./make install\n```\n至此libfastcommon就已经安装成功了,但注意一下上图中红色框标注的内容,libfastcommon.so 默认安装到了/usr/lib64/libfastcommon.so,但是FastDFS主程序设置的lib目录是/usr/local/lib,所以此处需要重新设置软链接(类似于Windows的快捷方式):\n```\nln -s /usr/lib64/libfastcommon.so /usr/local/lib/libfastcommon.so \nln -s /usr/lib64/libfastcommon.so /usr/lib/libfastcommon.so \nln -s /usr/lib64/libfdfsclient.so /usr/local/lib/libfdfsclient.so \nln -s /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so\n```\n* 4、安装fastfds\n进入fastfds的目录\n```\n./make.sh \n./make.sh install\n```\n安装完成，修改配置文件，到/etc/fdfs中运行\n```\ncp client.conf.sample client.conf \ncp storage.conf.sample storage.conf \ncp tracker.conf.sample tracker.conf\n```\n\n* 5、配置Tracker\n创建Tracker服务器的文件路径\n```\nmkdir /opt/fastdfs_tracker\n```\n编辑上一步准备好的/etc/fdfs目录下的**tracker.conf**配置如下：\n```\ndisabled=false#启用配置文件(默认启用) \nport=22122#设置tracker的端口号,通常采用22122这个默认端口 \nbase_path=/opt/fastdfs_tracker#设置tracker的数据文件和日志目录 \nhttp.server_port=6666#设置http端口号,默认为8080 \n```\n接着为启动脚本创建软引用,因为fdfs_trackerd等命令在/usr/local/bin中并没有。\n```\nln -s /usr/bin/fdfs_trackerd /usr/local/bin \nln -s /usr/bin/stop.sh /usr/local/bin \nln -s /usr/bin/restart.sh /usr/local/bin\n```\n\n最后启动Tracker服务器:\n```\nservice fdfs_trackerd start\n```\n查看启动状况\n```\nnetstat -unltp|grep fdfs\n```\n如下图表示成功了\n![Tracker.png](https://upload-images.jianshu.io/upload_images/13150128-fb8e12a4cb775cff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n* 6、配置Storage\n创建Storage服务器的文件目录\n```\nmkdir /opt/fastdfs_storage \nmkdir /opt/fastdfs_storage_data\n```\n接下来修改/etc/fdfs目录下的storage.conf配置文件,打开文件后依次做以下修改:\n```\ndisabled=false#启用配置文件(默认启用) \ngroup_name=group1#组名,根据实际情况修改 \nport=23000 #设置storage的端口号,默认是23000,同一个组的storage端口号必须一致 \nbase_path=/opt/fastdfs_storage#设置storage数据文件和日志目录 \nstore_path_count=1 #存储路径个数,需要和store_path个数匹配 \nstore_path0=/opt/fastdfs_storage_data #实际文件存储路径 \ntracker_server=192.168.112.16:22122 #tracker 服务器的 IP地址和端口号,如果是单机搭建,IP不要写127.0.0.1,否则启动不成功(此处的ip是我的CentOS虚拟机ip) \nhttp.server_port=8888#设置 http 端口号 \n```\n配置完成后同样要为Storage服务器的启动脚本设置软引用:\n```\nln -s /usr/bin/fdfs_storaged /usr/local/bin\n```\n启动Storage服务了:\n ```\nservice fdfs_storaged start\n```\n\n验证是否成功：\n可以到/opt/fastdfs_storage/data目录下生成好的pid文件和dat文件,那么再看一下实际文件存储路径下是否有创建好的多级目录呢: 如下图就是成功了。\n![Storage.png](https://upload-images.jianshu.io/upload_images/13150128-69da6bb62469a598.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n查看端口是否正常。\n```\nnetstat -unltp|grep fdfs\n```\n\n* 7、测试上传\n测试时需要设置客户端的配置文件,编辑/etc/fdfs目录下的client.conf 文件,打开文件后依次做以下修改:\n```\nbase_path=/opt/fastdfs_tracker#tracker服务器文件路径 \ntracker_server=192.168.111.11:22122#tracker服务器IP地址和端口号 \nhttp.tracker_server_port=6666# tracker 服务器的 http 端口号,必须和tracker的设置对应起来 \n```\n上传一张照片上去：\n例如：\n```\n/usr/bin/fdfs_upload_file /etc/fdfs/client.conf /opt/54ffac56000169c001840181.jpg\n```\n成功如下图\n![上传成功](https://upload-images.jianshu.io/upload_images/13150128-70681e2ea3da0cc3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n\n#### FastDFS与nginx进行集成\n* 1、加入模块\n加入模块命令：(对准你的fastdfs-nginx-module安装包）。\n```\n./configure --add-module=/usr/local/fast/fastdfs-nginx-module/src/\n\nmake && make install\n```\n\n复制fastdfs-ngin-module中的配置文件，到/etc/fdfs目录中\n```\ncp /usr/local/fast/fastdfs-nginx-module/src/mod_fastdfs.conf  /etc/fdfs/\n```\n修改mod_fastdfs.conf\n```\n#修改内容：比如连接超时时间、跟踪器路径配置、url的group配置、\nconnect_timeout=10\ntracker_server=192.168.1.172:22122\nurl_have_group_name = true\nstore_path0=/opt/fastdfs_storage_data #这个要跟storage的相同。\n```\n\n复制FastDFS里的2个文件，到/etc/fdfs目录中\n```\ncd /usr/local/fast/FastDFS/conf/\ncp http.conf mime.types /etc/fdfs/\n```\n\n创建一个软连接，在/fastdfs/storage文件存储目录下创建软连接，将其链接到实际存放数据的目录。\n```\nln -s /fastdfs/storage/data/ /fastdfs/storage/data/M00\n```\n修改配置nginx.conf\n\n![nginx配置.png](https://upload-images.jianshu.io/upload_images/13150128-316199ba69c78583.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)\n\n修改内容为：\n```\nlisten 8888;\n\nserver_name localhost;\nlocation ~/group([0-9])/M00 {\nroot /fastdfs/storage/data;\nngx_fastdfs_module;\n}\n```\n\n启动Nginx\n```\n/usr/local/nginx/sbin/nginx\n```\n\n\n现在我们使用这个ID用浏览器访问地址：\nhttp://120.79.226.4:8888/group1/M00/00/00/rBJeZVv4AbqAJlGpAACoAPN3PCk295.jpg\n\n\n**特别提醒：阿里云的端口需要到安全组配置里配置才能访问的。**\n\n![公众号.jpg](/api/file/download/c2f3da69ea454b07930e5929d068dba2.png)', null, null, null, null, null, '2019-03-05 21:30:07', '2019-03-05 21:53:31', '2019-03-05 21:53:31', null, null, null, '0');

-- ----------------------------
-- Table structure for article_likes
-- ----------------------------
DROP TABLE IF EXISTS `article_likes`;
CREATE TABLE `article_likes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) DEFAULT NULL COMMENT '用户id',
  `article_id` bigint(20) DEFAULT NULL,
  `ip_address` varchar(255) DEFAULT NULL COMMENT 'ip地址',
  `is_like` tinyint(2) DEFAULT NULL COMMENT '是否点赞：0为点赞，1为不点赞',
  `like_score` int(11) DEFAULT NULL COMMENT '点赞分数:1-5个等级',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_likes
-- ----------------------------
INSERT INTO `article_likes` VALUES ('1', null, '20', '0:0:0:0:0:0:0:1', null, null, '2019-03-09 23:06:30');
INSERT INTO `article_likes` VALUES ('2', 'a57064ef08ee4a61a76f45fc34849527', '20', '192.168.11.138', '1', null, '2019-03-10 14:33:43');
INSERT INTO `article_likes` VALUES ('3', 'a57064ef08ee4a61a76f45fc34849527', '19', '192.168.11.138', '1', null, '2019-03-10 14:34:07');
INSERT INTO `article_likes` VALUES ('4', 'a57064ef08ee4a61a76f45fc34849527', '40', '192.168.11.138', '1', null, '2019-03-10 14:34:54');
INSERT INTO `article_likes` VALUES ('5', 'a57064ef08ee4a61a76f45fc34849527', '36', '192.168.11.138', '1', null, '2019-03-10 14:39:01');
INSERT INTO `article_likes` VALUES ('6', 'ab29ab1bef724faabe86d348854c55ae', '38', '192.168.11.138', '1', null, '2019-03-16 11:54:10');
INSERT INTO `article_likes` VALUES ('7', 'ab29ab1bef724faabe86d348854c55ae', '39', '192.168.11.138', '1', null, '2019-03-16 11:56:11');
INSERT INTO `article_likes` VALUES ('8', 'a57064ef08ee4a61a76f45fc34849527', '38', '192.168.11.138', '1', null, '2019-03-16 12:19:16');
INSERT INTO `article_likes` VALUES ('9', 'a57064ef08ee4a61a76f45fc34849527', '35', '192.168.11.138', '1', null, '2019-03-16 12:22:24');

-- ----------------------------
-- Table structure for article_visit_log
-- ----------------------------
DROP TABLE IF EXISTS `article_visit_log`;
CREATE TABLE `article_visit_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) DEFAULT NULL COMMENT '被访问文章的id',
  `user_id` varchar(255) DEFAULT NULL COMMENT '用户id',
  `ip_address` varchar(255) DEFAULT NULL COMMENT 'ip地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=561 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of article_visit_log
-- ----------------------------
INSERT INTO `article_visit_log` VALUES ('1', '38', null, null, '2019-03-09 22:07:58');
INSERT INTO `article_visit_log` VALUES ('2', '20', null, null, '2019-03-09 23:22:40');
INSERT INTO `article_visit_log` VALUES ('3', '38', null, null, '2019-03-10 08:52:48');
INSERT INTO `article_visit_log` VALUES ('4', '37', null, null, '2019-03-10 08:53:09');
INSERT INTO `article_visit_log` VALUES ('5', '38', null, null, '2019-03-10 09:28:35');
INSERT INTO `article_visit_log` VALUES ('6', '38', null, null, '2019-03-10 11:28:37');
INSERT INTO `article_visit_log` VALUES ('7', '39', null, null, '2019-03-10 11:28:43');
INSERT INTO `article_visit_log` VALUES ('8', '38', null, null, '2019-03-10 11:32:35');
INSERT INTO `article_visit_log` VALUES ('9', '38', null, null, '2019-03-10 11:35:57');
INSERT INTO `article_visit_log` VALUES ('10', '38', null, null, '2019-03-10 11:45:47');
INSERT INTO `article_visit_log` VALUES ('11', '38', null, null, '2019-03-10 11:58:28');
INSERT INTO `article_visit_log` VALUES ('12', '38', null, null, '2019-03-10 12:05:50');
INSERT INTO `article_visit_log` VALUES ('13', '38', null, null, '2019-03-10 12:06:29');
INSERT INTO `article_visit_log` VALUES ('14', '38', null, null, '2019-03-10 13:46:43');
INSERT INTO `article_visit_log` VALUES ('15', '38', null, null, '2019-03-10 13:47:12');
INSERT INTO `article_visit_log` VALUES ('16', '38', null, null, '2019-03-10 14:09:48');
INSERT INTO `article_visit_log` VALUES ('17', '38', null, null, '2019-03-10 14:10:55');
INSERT INTO `article_visit_log` VALUES ('18', '38', null, null, '2019-03-10 14:11:55');
INSERT INTO `article_visit_log` VALUES ('19', '38', null, null, '2019-03-10 14:12:45');
INSERT INTO `article_visit_log` VALUES ('20', '38', null, null, '2019-03-10 14:16:25');
INSERT INTO `article_visit_log` VALUES ('21', '38', null, null, '2019-03-10 14:16:31');
INSERT INTO `article_visit_log` VALUES ('22', '38', null, null, '2019-03-10 14:16:42');
INSERT INTO `article_visit_log` VALUES ('23', '38', null, null, '2019-03-10 14:17:32');
INSERT INTO `article_visit_log` VALUES ('24', '38', null, null, '2019-03-10 14:18:00');
INSERT INTO `article_visit_log` VALUES ('25', '38', null, null, '2019-03-10 14:18:09');
INSERT INTO `article_visit_log` VALUES ('26', '38', null, null, '2019-03-10 14:20:20');
INSERT INTO `article_visit_log` VALUES ('27', '40', null, null, '2019-03-10 14:27:18');
INSERT INTO `article_visit_log` VALUES ('28', '37', null, null, '2019-03-10 14:27:37');
INSERT INTO `article_visit_log` VALUES ('29', '37', null, null, '2019-03-10 14:29:33');
INSERT INTO `article_visit_log` VALUES ('30', '40', null, null, '2019-03-10 14:29:53');
INSERT INTO `article_visit_log` VALUES ('31', '22', null, null, '2019-03-10 14:30:08');
INSERT INTO `article_visit_log` VALUES ('32', '20', null, null, '2019-03-10 14:31:09');
INSERT INTO `article_visit_log` VALUES ('33', '19', null, null, '2019-03-10 14:33:56');
INSERT INTO `article_visit_log` VALUES ('34', '19', null, null, '2019-03-10 14:34:15');
INSERT INTO `article_visit_log` VALUES ('35', '40', null, null, '2019-03-10 14:34:48');
INSERT INTO `article_visit_log` VALUES ('36', '22', null, null, '2019-03-10 14:35:07');
INSERT INTO `article_visit_log` VALUES ('37', '22', null, null, '2019-03-10 14:38:19');
INSERT INTO `article_visit_log` VALUES ('38', '36', null, null, '2019-03-10 14:38:36');
INSERT INTO `article_visit_log` VALUES ('39', '36', null, null, '2019-03-10 14:38:57');
INSERT INTO `article_visit_log` VALUES ('40', '34', null, null, '2019-03-10 14:40:47');
INSERT INTO `article_visit_log` VALUES ('41', '38', null, null, '2019-03-10 14:41:02');
INSERT INTO `article_visit_log` VALUES ('42', '33', null, null, '2019-03-10 14:42:04');
INSERT INTO `article_visit_log` VALUES ('43', '35', null, null, '2019-03-10 14:47:42');
INSERT INTO `article_visit_log` VALUES ('44', '35', null, null, '2019-03-10 14:52:22');
INSERT INTO `article_visit_log` VALUES ('45', '35', null, null, '2019-03-10 14:53:37');
INSERT INTO `article_visit_log` VALUES ('46', '35', null, null, '2019-03-10 14:56:01');
INSERT INTO `article_visit_log` VALUES ('47', '38', null, null, '2019-03-10 14:56:09');
INSERT INTO `article_visit_log` VALUES ('48', '38', null, null, '2019-03-10 14:57:09');
INSERT INTO `article_visit_log` VALUES ('49', '38', null, null, '2019-03-10 15:07:13');
INSERT INTO `article_visit_log` VALUES ('50', '38', null, null, '2019-03-10 15:08:06');
INSERT INTO `article_visit_log` VALUES ('51', '38', null, null, '2019-03-10 15:09:45');
INSERT INTO `article_visit_log` VALUES ('52', '38', null, null, '2019-03-10 15:14:16');
INSERT INTO `article_visit_log` VALUES ('53', '40', null, null, '2019-03-10 15:14:38');
INSERT INTO `article_visit_log` VALUES ('54', '34', null, null, '2019-03-10 15:14:45');
INSERT INTO `article_visit_log` VALUES ('55', '34', null, null, '2019-03-10 15:15:00');
INSERT INTO `article_visit_log` VALUES ('56', '34', null, null, '2019-03-10 15:17:41');
INSERT INTO `article_visit_log` VALUES ('57', '34', null, null, '2019-03-10 15:17:49');
INSERT INTO `article_visit_log` VALUES ('58', '34', null, null, '2019-03-10 15:18:24');
INSERT INTO `article_visit_log` VALUES ('59', '34', null, null, '2019-03-10 15:19:18');
INSERT INTO `article_visit_log` VALUES ('60', '38', null, null, '2019-03-10 15:28:17');
INSERT INTO `article_visit_log` VALUES ('61', '38', null, null, '2019-03-10 15:29:26');
INSERT INTO `article_visit_log` VALUES ('62', '38', null, null, '2019-03-10 15:30:17');
INSERT INTO `article_visit_log` VALUES ('63', '38', null, null, '2019-03-10 15:30:22');
INSERT INTO `article_visit_log` VALUES ('64', '32', null, null, '2019-03-10 15:33:53');
INSERT INTO `article_visit_log` VALUES ('65', '32', null, null, '2019-03-10 15:36:09');
INSERT INTO `article_visit_log` VALUES ('66', '32', null, null, '2019-03-10 15:38:32');
INSERT INTO `article_visit_log` VALUES ('67', '34', null, null, '2019-03-10 15:45:01');
INSERT INTO `article_visit_log` VALUES ('68', '34', null, null, '2019-03-10 15:50:21');
INSERT INTO `article_visit_log` VALUES ('69', '34', null, null, '2019-03-10 15:53:26');
INSERT INTO `article_visit_log` VALUES ('70', '34', null, null, '2019-03-10 15:53:36');
INSERT INTO `article_visit_log` VALUES ('71', '34', null, null, '2019-03-10 15:54:25');
INSERT INTO `article_visit_log` VALUES ('72', '34', null, null, '2019-03-10 15:55:06');
INSERT INTO `article_visit_log` VALUES ('73', '34', null, null, '2019-03-10 15:55:11');
INSERT INTO `article_visit_log` VALUES ('74', '34', null, null, '2019-03-10 15:56:08');
INSERT INTO `article_visit_log` VALUES ('75', '34', null, null, '2019-03-10 15:56:48');
INSERT INTO `article_visit_log` VALUES ('76', '34', null, null, '2019-03-10 16:09:17');
INSERT INTO `article_visit_log` VALUES ('77', '34', null, null, '2019-03-10 16:10:00');
INSERT INTO `article_visit_log` VALUES ('78', '34', null, null, '2019-03-10 16:10:52');
INSERT INTO `article_visit_log` VALUES ('79', '34', null, null, '2019-03-10 16:10:56');
INSERT INTO `article_visit_log` VALUES ('80', '34', null, null, '2019-03-10 16:11:07');
INSERT INTO `article_visit_log` VALUES ('81', '34', null, null, '2019-03-10 16:12:26');
INSERT INTO `article_visit_log` VALUES ('82', '34', null, null, '2019-03-10 16:13:30');
INSERT INTO `article_visit_log` VALUES ('83', '34', null, null, '2019-03-10 16:14:37');
INSERT INTO `article_visit_log` VALUES ('84', '34', null, null, '2019-03-10 16:15:58');
INSERT INTO `article_visit_log` VALUES ('85', '34', null, null, '2019-03-10 16:16:16');
INSERT INTO `article_visit_log` VALUES ('86', '34', null, null, '2019-03-10 16:16:32');
INSERT INTO `article_visit_log` VALUES ('87', '34', null, null, '2019-03-10 16:17:13');
INSERT INTO `article_visit_log` VALUES ('88', '34', null, null, '2019-03-10 16:18:34');
INSERT INTO `article_visit_log` VALUES ('89', '34', null, null, '2019-03-10 16:19:26');
INSERT INTO `article_visit_log` VALUES ('90', '34', null, null, '2019-03-10 16:20:52');
INSERT INTO `article_visit_log` VALUES ('91', '34', null, null, '2019-03-10 16:21:30');
INSERT INTO `article_visit_log` VALUES ('92', '34', null, null, '2019-03-10 16:23:08');
INSERT INTO `article_visit_log` VALUES ('93', '34', null, null, '2019-03-10 16:23:24');
INSERT INTO `article_visit_log` VALUES ('94', '34', null, null, '2019-03-10 16:24:05');
INSERT INTO `article_visit_log` VALUES ('95', '34', null, null, '2019-03-10 16:24:11');
INSERT INTO `article_visit_log` VALUES ('96', '34', null, null, '2019-03-10 16:24:16');
INSERT INTO `article_visit_log` VALUES ('97', '34', null, null, '2019-03-10 16:24:28');
INSERT INTO `article_visit_log` VALUES ('98', '34', null, null, '2019-03-10 16:24:39');
INSERT INTO `article_visit_log` VALUES ('99', '34', null, null, '2019-03-10 16:24:45');
INSERT INTO `article_visit_log` VALUES ('100', '34', null, null, '2019-03-10 16:25:06');
INSERT INTO `article_visit_log` VALUES ('101', '34', null, null, '2019-03-10 16:31:31');
INSERT INTO `article_visit_log` VALUES ('102', '34', null, null, '2019-03-10 16:32:32');
INSERT INTO `article_visit_log` VALUES ('103', '34', null, null, '2019-03-10 16:34:02');
INSERT INTO `article_visit_log` VALUES ('104', '34', null, null, '2019-03-10 16:34:19');
INSERT INTO `article_visit_log` VALUES ('105', '34', null, null, '2019-03-10 16:35:34');
INSERT INTO `article_visit_log` VALUES ('106', '34', null, null, '2019-03-10 16:36:49');
INSERT INTO `article_visit_log` VALUES ('107', '34', null, null, '2019-03-10 16:37:23');
INSERT INTO `article_visit_log` VALUES ('108', '34', null, null, '2019-03-10 16:37:44');
INSERT INTO `article_visit_log` VALUES ('109', '34', null, null, '2019-03-10 16:38:02');
INSERT INTO `article_visit_log` VALUES ('110', '34', null, null, '2019-03-10 16:42:22');
INSERT INTO `article_visit_log` VALUES ('111', '34', null, null, '2019-03-10 16:42:50');
INSERT INTO `article_visit_log` VALUES ('112', '34', null, null, '2019-03-10 16:45:24');
INSERT INTO `article_visit_log` VALUES ('113', '34', null, null, '2019-03-10 16:45:48');
INSERT INTO `article_visit_log` VALUES ('114', '34', null, null, '2019-03-10 16:46:13');
INSERT INTO `article_visit_log` VALUES ('115', '34', null, null, '2019-03-10 16:47:11');
INSERT INTO `article_visit_log` VALUES ('116', '34', null, null, '2019-03-10 16:47:23');
INSERT INTO `article_visit_log` VALUES ('117', '38', null, null, '2019-03-10 19:02:06');
INSERT INTO `article_visit_log` VALUES ('118', '38', null, null, '2019-03-10 19:04:28');
INSERT INTO `article_visit_log` VALUES ('119', '38', null, null, '2019-03-10 19:06:11');
INSERT INTO `article_visit_log` VALUES ('120', '38', null, null, '2019-03-10 20:32:41');
INSERT INTO `article_visit_log` VALUES ('121', '38', null, null, '2019-03-10 20:33:39');
INSERT INTO `article_visit_log` VALUES ('122', '38', null, null, '2019-03-10 20:42:30');
INSERT INTO `article_visit_log` VALUES ('123', '35', null, null, '2019-03-10 20:43:40');
INSERT INTO `article_visit_log` VALUES ('124', '35', null, null, '2019-03-10 21:54:44');
INSERT INTO `article_visit_log` VALUES ('125', '35', null, null, '2019-03-10 21:55:18');
INSERT INTO `article_visit_log` VALUES ('126', '35', null, null, '2019-03-10 21:55:45');
INSERT INTO `article_visit_log` VALUES ('127', '35', null, null, '2019-03-10 21:56:05');
INSERT INTO `article_visit_log` VALUES ('128', '35', null, null, '2019-03-10 21:56:49');
INSERT INTO `article_visit_log` VALUES ('129', '35', null, null, '2019-03-10 21:58:59');
INSERT INTO `article_visit_log` VALUES ('130', '35', null, null, '2019-03-10 22:01:37');
INSERT INTO `article_visit_log` VALUES ('131', '35', null, null, '2019-03-10 22:01:44');
INSERT INTO `article_visit_log` VALUES ('132', '38', null, null, '2019-03-10 22:41:06');
INSERT INTO `article_visit_log` VALUES ('133', '38', null, null, '2019-03-10 22:44:20');
INSERT INTO `article_visit_log` VALUES ('134', '38', null, null, '2019-03-10 22:45:10');
INSERT INTO `article_visit_log` VALUES ('135', '38', null, null, '2019-03-10 22:46:38');
INSERT INTO `article_visit_log` VALUES ('136', '38', null, null, '2019-03-10 22:46:57');
INSERT INTO `article_visit_log` VALUES ('137', '38', null, null, '2019-03-10 22:47:27');
INSERT INTO `article_visit_log` VALUES ('138', '38', null, null, '2019-03-10 22:48:51');
INSERT INTO `article_visit_log` VALUES ('139', '38', null, null, '2019-03-10 22:48:51');
INSERT INTO `article_visit_log` VALUES ('140', '38', null, null, '2019-03-10 22:49:10');
INSERT INTO `article_visit_log` VALUES ('141', '38', null, null, '2019-03-10 22:49:24');
INSERT INTO `article_visit_log` VALUES ('142', '38', null, null, '2019-03-10 22:49:45');
INSERT INTO `article_visit_log` VALUES ('143', '38', null, null, '2019-03-10 22:50:01');
INSERT INTO `article_visit_log` VALUES ('144', '38', null, null, '2019-03-10 22:51:40');
INSERT INTO `article_visit_log` VALUES ('145', '38', null, null, '2019-03-10 22:52:56');
INSERT INTO `article_visit_log` VALUES ('146', '38', null, null, '2019-03-10 22:52:59');
INSERT INTO `article_visit_log` VALUES ('147', '38', null, null, '2019-03-10 22:54:48');
INSERT INTO `article_visit_log` VALUES ('148', '37', null, null, '2019-03-10 22:54:58');
INSERT INTO `article_visit_log` VALUES ('149', '37', null, null, '2019-03-10 22:55:42');
INSERT INTO `article_visit_log` VALUES ('150', '38', null, null, '2019-03-10 22:55:49');
INSERT INTO `article_visit_log` VALUES ('151', '38', null, null, '2019-03-10 22:56:37');
INSERT INTO `article_visit_log` VALUES ('152', '38', null, null, '2019-03-10 22:57:36');
INSERT INTO `article_visit_log` VALUES ('153', '38', null, null, '2019-03-10 22:57:42');
INSERT INTO `article_visit_log` VALUES ('154', '38', null, null, '2019-03-10 22:59:48');
INSERT INTO `article_visit_log` VALUES ('155', '38', null, null, '2019-03-10 23:00:17');
INSERT INTO `article_visit_log` VALUES ('156', '38', null, null, '2019-03-10 23:02:17');
INSERT INTO `article_visit_log` VALUES ('157', '38', null, null, '2019-03-10 23:03:14');
INSERT INTO `article_visit_log` VALUES ('158', '38', null, null, '2019-03-10 23:03:18');
INSERT INTO `article_visit_log` VALUES ('159', '38', null, null, '2019-03-10 23:08:13');
INSERT INTO `article_visit_log` VALUES ('160', '40', null, null, '2019-03-10 23:08:26');
INSERT INTO `article_visit_log` VALUES ('161', '40', null, null, '2019-03-10 23:09:25');
INSERT INTO `article_visit_log` VALUES ('162', '40', null, null, '2019-03-10 23:09:37');
INSERT INTO `article_visit_log` VALUES ('163', '40', null, null, '2019-03-10 23:10:05');
INSERT INTO `article_visit_log` VALUES ('164', '40', null, null, '2019-03-10 23:11:58');
INSERT INTO `article_visit_log` VALUES ('165', '40', null, null, '2019-03-10 23:12:16');
INSERT INTO `article_visit_log` VALUES ('166', '40', null, null, '2019-03-10 23:12:40');
INSERT INTO `article_visit_log` VALUES ('167', '40', null, null, '2019-03-10 23:14:59');
INSERT INTO `article_visit_log` VALUES ('168', '40', null, null, '2019-03-10 23:15:47');
INSERT INTO `article_visit_log` VALUES ('169', '36', null, null, '2019-03-10 23:17:45');
INSERT INTO `article_visit_log` VALUES ('170', '36', null, null, '2019-03-10 23:18:22');
INSERT INTO `article_visit_log` VALUES ('171', '39', null, null, '2019-03-11 19:18:42');
INSERT INTO `article_visit_log` VALUES ('172', '38', null, null, '2019-03-12 19:46:11');
INSERT INTO `article_visit_log` VALUES ('173', '36', null, null, '2019-03-12 19:56:56');
INSERT INTO `article_visit_log` VALUES ('174', '34', null, null, '2019-03-12 20:18:34');
INSERT INTO `article_visit_log` VALUES ('175', '38', null, null, '2019-03-12 20:19:26');
INSERT INTO `article_visit_log` VALUES ('176', '38', null, null, '2019-03-12 20:30:18');
INSERT INTO `article_visit_log` VALUES ('177', '38', null, null, '2019-03-12 20:34:28');
INSERT INTO `article_visit_log` VALUES ('178', '36', null, null, '2019-03-12 20:35:41');
INSERT INTO `article_visit_log` VALUES ('179', '36', null, null, '2019-03-12 20:35:53');
INSERT INTO `article_visit_log` VALUES ('180', '35', null, null, '2019-03-12 20:36:17');
INSERT INTO `article_visit_log` VALUES ('181', '38', null, null, '2019-03-12 20:49:08');
INSERT INTO `article_visit_log` VALUES ('182', '36', null, null, '2019-03-12 20:49:08');
INSERT INTO `article_visit_log` VALUES ('183', '36', null, null, '2019-03-12 20:49:16');
INSERT INTO `article_visit_log` VALUES ('184', '38', null, null, '2019-03-12 20:49:17');
INSERT INTO `article_visit_log` VALUES ('185', '36', null, null, '2019-03-12 20:49:22');
INSERT INTO `article_visit_log` VALUES ('186', '38', null, null, '2019-03-12 20:49:27');
INSERT INTO `article_visit_log` VALUES ('187', '38', null, null, '2019-03-12 20:51:37');
INSERT INTO `article_visit_log` VALUES ('188', '38', null, null, '2019-03-12 21:54:11');
INSERT INTO `article_visit_log` VALUES ('189', '38', null, null, '2019-03-12 21:55:54');
INSERT INTO `article_visit_log` VALUES ('190', '38', null, null, '2019-03-12 21:59:54');
INSERT INTO `article_visit_log` VALUES ('191', '38', null, null, '2019-03-12 22:12:53');
INSERT INTO `article_visit_log` VALUES ('192', '38', null, null, '2019-03-12 22:16:09');
INSERT INTO `article_visit_log` VALUES ('193', '38', null, null, '2019-03-12 22:18:38');
INSERT INTO `article_visit_log` VALUES ('194', '38', null, null, '2019-03-12 22:21:17');
INSERT INTO `article_visit_log` VALUES ('195', '38', null, null, '2019-03-12 22:22:28');
INSERT INTO `article_visit_log` VALUES ('196', '38', null, null, '2019-03-12 22:22:44');
INSERT INTO `article_visit_log` VALUES ('197', '38', null, null, '2019-03-12 22:23:06');
INSERT INTO `article_visit_log` VALUES ('198', '38', null, null, '2019-03-12 22:23:13');
INSERT INTO `article_visit_log` VALUES ('199', '38', null, null, '2019-03-12 22:23:45');
INSERT INTO `article_visit_log` VALUES ('200', '38', null, null, '2019-03-12 22:23:57');
INSERT INTO `article_visit_log` VALUES ('201', '38', null, null, '2019-03-12 22:24:07');
INSERT INTO `article_visit_log` VALUES ('202', '38', null, null, '2019-03-12 22:24:37');
INSERT INTO `article_visit_log` VALUES ('203', '38', null, null, '2019-03-12 22:25:08');
INSERT INTO `article_visit_log` VALUES ('204', '38', null, null, '2019-03-12 22:25:13');
INSERT INTO `article_visit_log` VALUES ('205', '38', null, null, '2019-03-12 22:25:37');
INSERT INTO `article_visit_log` VALUES ('206', '38', null, null, '2019-03-12 22:29:40');
INSERT INTO `article_visit_log` VALUES ('207', '38', null, null, '2019-03-12 22:30:24');
INSERT INTO `article_visit_log` VALUES ('208', '38', null, null, '2019-03-12 22:31:00');
INSERT INTO `article_visit_log` VALUES ('209', '38', null, null, '2019-03-12 22:32:51');
INSERT INTO `article_visit_log` VALUES ('210', '38', null, null, '2019-03-12 22:33:14');
INSERT INTO `article_visit_log` VALUES ('211', '38', null, null, '2019-03-12 22:36:23');
INSERT INTO `article_visit_log` VALUES ('212', '38', null, null, '2019-03-12 22:36:56');
INSERT INTO `article_visit_log` VALUES ('213', '38', null, null, '2019-03-12 22:38:14');
INSERT INTO `article_visit_log` VALUES ('214', '38', null, null, '2019-03-12 22:38:31');
INSERT INTO `article_visit_log` VALUES ('215', '38', null, null, '2019-03-12 22:39:12');
INSERT INTO `article_visit_log` VALUES ('216', '38', null, null, '2019-03-12 22:50:19');
INSERT INTO `article_visit_log` VALUES ('217', '38', null, null, '2019-03-12 22:50:44');
INSERT INTO `article_visit_log` VALUES ('218', '38', null, null, '2019-03-12 22:52:20');
INSERT INTO `article_visit_log` VALUES ('219', '38', null, null, '2019-03-12 22:55:14');
INSERT INTO `article_visit_log` VALUES ('220', '38', null, null, '2019-03-12 22:57:33');
INSERT INTO `article_visit_log` VALUES ('221', '38', null, null, '2019-03-12 22:57:49');
INSERT INTO `article_visit_log` VALUES ('222', '38', null, null, '2019-03-12 22:58:33');
INSERT INTO `article_visit_log` VALUES ('223', '38', null, null, '2019-03-12 22:59:34');
INSERT INTO `article_visit_log` VALUES ('224', '38', null, null, '2019-03-12 23:00:16');
INSERT INTO `article_visit_log` VALUES ('225', '38', null, null, '2019-03-12 23:33:33');
INSERT INTO `article_visit_log` VALUES ('226', '38', null, null, '2019-03-12 23:40:00');
INSERT INTO `article_visit_log` VALUES ('227', '38', null, null, '2019-03-12 23:41:48');
INSERT INTO `article_visit_log` VALUES ('228', '38', null, null, '2019-03-13 19:27:08');
INSERT INTO `article_visit_log` VALUES ('229', '37', null, null, '2019-03-15 19:43:11');
INSERT INTO `article_visit_log` VALUES ('230', '37', null, null, '2019-03-15 19:58:14');
INSERT INTO `article_visit_log` VALUES ('231', '37', null, null, '2019-03-15 19:58:56');
INSERT INTO `article_visit_log` VALUES ('232', '37', null, null, '2019-03-15 19:59:23');
INSERT INTO `article_visit_log` VALUES ('233', '37', null, null, '2019-03-15 20:02:29');
INSERT INTO `article_visit_log` VALUES ('234', '37', null, null, '2019-03-15 20:03:14');
INSERT INTO `article_visit_log` VALUES ('235', '37', null, null, '2019-03-15 20:03:59');
INSERT INTO `article_visit_log` VALUES ('236', '38', null, null, '2019-03-15 20:04:24');
INSERT INTO `article_visit_log` VALUES ('237', '38', null, null, '2019-03-15 20:05:42');
INSERT INTO `article_visit_log` VALUES ('238', '38', null, null, '2019-03-15 20:15:10');
INSERT INTO `article_visit_log` VALUES ('239', '38', null, null, '2019-03-15 20:15:46');
INSERT INTO `article_visit_log` VALUES ('240', '38', null, null, '2019-03-15 20:15:57');
INSERT INTO `article_visit_log` VALUES ('241', '38', null, null, '2019-03-15 20:17:36');
INSERT INTO `article_visit_log` VALUES ('242', '35', null, null, '2019-03-15 20:18:09');
INSERT INTO `article_visit_log` VALUES ('243', '39', null, null, '2019-03-15 20:22:28');
INSERT INTO `article_visit_log` VALUES ('244', '36', null, null, '2019-03-15 20:30:27');
INSERT INTO `article_visit_log` VALUES ('245', '36', null, null, '2019-03-15 20:38:12');
INSERT INTO `article_visit_log` VALUES ('246', '36', null, null, '2019-03-15 20:40:30');
INSERT INTO `article_visit_log` VALUES ('247', '36', null, null, '2019-03-15 20:41:32');
INSERT INTO `article_visit_log` VALUES ('248', '36', null, null, '2019-03-15 20:45:56');
INSERT INTO `article_visit_log` VALUES ('249', '36', null, null, '2019-03-15 20:46:06');
INSERT INTO `article_visit_log` VALUES ('250', '36', null, null, '2019-03-15 20:50:47');
INSERT INTO `article_visit_log` VALUES ('251', '36', null, null, '2019-03-15 20:51:48');
INSERT INTO `article_visit_log` VALUES ('252', '36', null, null, '2019-03-15 20:54:00');
INSERT INTO `article_visit_log` VALUES ('253', '36', null, null, '2019-03-15 20:54:05');
INSERT INTO `article_visit_log` VALUES ('254', '36', null, null, '2019-03-15 20:54:37');
INSERT INTO `article_visit_log` VALUES ('255', '36', null, null, '2019-03-15 20:59:01');
INSERT INTO `article_visit_log` VALUES ('256', '36', null, null, '2019-03-15 20:59:17');
INSERT INTO `article_visit_log` VALUES ('257', '36', null, null, '2019-03-15 21:05:35');
INSERT INTO `article_visit_log` VALUES ('258', '36', null, null, '2019-03-15 21:05:52');
INSERT INTO `article_visit_log` VALUES ('259', '36', null, null, '2019-03-15 21:06:38');
INSERT INTO `article_visit_log` VALUES ('260', '36', null, null, '2019-03-15 21:06:42');
INSERT INTO `article_visit_log` VALUES ('261', '36', null, null, '2019-03-15 21:07:04');
INSERT INTO `article_visit_log` VALUES ('262', '40', null, null, '2019-03-15 21:09:10');
INSERT INTO `article_visit_log` VALUES ('263', '40', null, null, '2019-03-15 21:11:02');
INSERT INTO `article_visit_log` VALUES ('264', '40', null, null, '2019-03-15 21:34:53');
INSERT INTO `article_visit_log` VALUES ('265', '40', null, null, '2019-03-15 21:35:52');
INSERT INTO `article_visit_log` VALUES ('266', '40', null, null, '2019-03-15 21:36:58');
INSERT INTO `article_visit_log` VALUES ('267', '40', null, null, '2019-03-15 21:39:24');
INSERT INTO `article_visit_log` VALUES ('268', '40', null, null, '2019-03-15 21:40:05');
INSERT INTO `article_visit_log` VALUES ('269', '40', null, null, '2019-03-15 21:41:00');
INSERT INTO `article_visit_log` VALUES ('270', '40', null, null, '2019-03-15 21:41:31');
INSERT INTO `article_visit_log` VALUES ('271', '40', null, null, '2019-03-15 21:43:24');
INSERT INTO `article_visit_log` VALUES ('272', '40', null, null, '2019-03-15 21:44:14');
INSERT INTO `article_visit_log` VALUES ('273', '40', null, null, '2019-03-15 21:44:38');
INSERT INTO `article_visit_log` VALUES ('274', '40', null, null, '2019-03-15 21:44:53');
INSERT INTO `article_visit_log` VALUES ('275', '40', null, null, '2019-03-15 21:45:12');
INSERT INTO `article_visit_log` VALUES ('276', '40', null, null, '2019-03-15 21:45:16');
INSERT INTO `article_visit_log` VALUES ('277', '37', null, null, '2019-03-15 22:37:40');
INSERT INTO `article_visit_log` VALUES ('278', '37', null, null, '2019-03-15 23:12:57');
INSERT INTO `article_visit_log` VALUES ('279', '37', null, null, '2019-03-15 23:12:57');
INSERT INTO `article_visit_log` VALUES ('280', '37', null, null, '2019-03-15 23:13:34');
INSERT INTO `article_visit_log` VALUES ('281', '37', null, null, '2019-03-15 23:13:40');
INSERT INTO `article_visit_log` VALUES ('282', '37', null, null, '2019-03-15 23:14:33');
INSERT INTO `article_visit_log` VALUES ('283', '37', null, null, '2019-03-15 23:14:53');
INSERT INTO `article_visit_log` VALUES ('284', '37', null, null, '2019-03-15 23:15:30');
INSERT INTO `article_visit_log` VALUES ('285', '37', null, null, '2019-03-15 23:16:11');
INSERT INTO `article_visit_log` VALUES ('286', '37', null, null, '2019-03-15 23:17:00');
INSERT INTO `article_visit_log` VALUES ('287', '37', null, null, '2019-03-15 23:17:00');
INSERT INTO `article_visit_log` VALUES ('288', '37', null, null, '2019-03-15 23:17:23');
INSERT INTO `article_visit_log` VALUES ('289', '37', null, null, '2019-03-15 23:18:54');
INSERT INTO `article_visit_log` VALUES ('290', '37', null, null, '2019-03-15 23:19:27');
INSERT INTO `article_visit_log` VALUES ('291', '37', null, null, '2019-03-15 23:21:41');
INSERT INTO `article_visit_log` VALUES ('292', '37', null, null, '2019-03-15 23:22:37');
INSERT INTO `article_visit_log` VALUES ('293', '39', null, null, '2019-03-15 23:22:46');
INSERT INTO `article_visit_log` VALUES ('294', '37', null, null, '2019-03-15 23:26:31');
INSERT INTO `article_visit_log` VALUES ('295', '37', null, null, '2019-03-15 23:30:29');
INSERT INTO `article_visit_log` VALUES ('296', '37', null, null, '2019-03-15 23:47:56');
INSERT INTO `article_visit_log` VALUES ('297', '37', null, null, '2019-03-15 23:49:08');
INSERT INTO `article_visit_log` VALUES ('298', '37', null, null, '2019-03-16 09:00:20');
INSERT INTO `article_visit_log` VALUES ('299', '37', null, null, '2019-03-16 09:06:58');
INSERT INTO `article_visit_log` VALUES ('300', '37', null, null, '2019-03-16 09:08:16');
INSERT INTO `article_visit_log` VALUES ('301', '37', null, null, '2019-03-16 09:08:40');
INSERT INTO `article_visit_log` VALUES ('302', '37', null, null, '2019-03-16 09:10:34');
INSERT INTO `article_visit_log` VALUES ('303', '37', null, null, '2019-03-16 09:10:55');
INSERT INTO `article_visit_log` VALUES ('304', '37', null, null, '2019-03-16 09:11:08');
INSERT INTO `article_visit_log` VALUES ('305', '37', null, null, '2019-03-16 09:11:49');
INSERT INTO `article_visit_log` VALUES ('306', '37', null, null, '2019-03-16 09:12:10');
INSERT INTO `article_visit_log` VALUES ('307', '37', null, null, '2019-03-16 09:12:36');
INSERT INTO `article_visit_log` VALUES ('308', '37', null, null, '2019-03-16 09:12:43');
INSERT INTO `article_visit_log` VALUES ('309', '37', null, null, '2019-03-16 09:20:22');
INSERT INTO `article_visit_log` VALUES ('310', '37', null, null, '2019-03-16 09:20:26');
INSERT INTO `article_visit_log` VALUES ('311', '37', null, null, '2019-03-16 09:20:37');
INSERT INTO `article_visit_log` VALUES ('312', '37', null, null, '2019-03-16 09:21:19');
INSERT INTO `article_visit_log` VALUES ('313', '37', null, null, '2019-03-16 09:22:34');
INSERT INTO `article_visit_log` VALUES ('314', '37', null, null, '2019-03-16 09:26:48');
INSERT INTO `article_visit_log` VALUES ('315', '37', null, null, '2019-03-16 09:27:30');
INSERT INTO `article_visit_log` VALUES ('316', '37', null, null, '2019-03-16 09:28:16');
INSERT INTO `article_visit_log` VALUES ('317', '37', null, null, '2019-03-16 09:28:35');
INSERT INTO `article_visit_log` VALUES ('318', '37', null, null, '2019-03-16 09:30:36');
INSERT INTO `article_visit_log` VALUES ('319', '37', null, null, '2019-03-16 09:30:59');
INSERT INTO `article_visit_log` VALUES ('320', '37', null, null, '2019-03-16 09:31:35');
INSERT INTO `article_visit_log` VALUES ('321', '37', null, null, '2019-03-16 09:32:28');
INSERT INTO `article_visit_log` VALUES ('322', '37', null, null, '2019-03-16 09:33:15');
INSERT INTO `article_visit_log` VALUES ('323', '37', null, null, '2019-03-16 09:35:18');
INSERT INTO `article_visit_log` VALUES ('324', '37', null, null, '2019-03-16 09:36:01');
INSERT INTO `article_visit_log` VALUES ('325', '37', null, null, '2019-03-16 09:37:16');
INSERT INTO `article_visit_log` VALUES ('326', '37', null, null, '2019-03-16 09:38:02');
INSERT INTO `article_visit_log` VALUES ('327', '37', null, null, '2019-03-16 09:42:37');
INSERT INTO `article_visit_log` VALUES ('328', '37', null, null, '2019-03-16 10:20:22');
INSERT INTO `article_visit_log` VALUES ('329', '37', null, null, '2019-03-16 10:22:10');
INSERT INTO `article_visit_log` VALUES ('330', '37', null, null, '2019-03-16 10:26:46');
INSERT INTO `article_visit_log` VALUES ('331', '37', null, null, '2019-03-16 10:27:51');
INSERT INTO `article_visit_log` VALUES ('332', '37', null, null, '2019-03-16 10:30:55');
INSERT INTO `article_visit_log` VALUES ('333', '37', null, null, '2019-03-16 10:31:54');
INSERT INTO `article_visit_log` VALUES ('334', '37', null, null, '2019-03-16 10:32:17');
INSERT INTO `article_visit_log` VALUES ('335', '37', null, null, '2019-03-16 10:32:39');
INSERT INTO `article_visit_log` VALUES ('336', '37', null, null, '2019-03-16 10:33:06');
INSERT INTO `article_visit_log` VALUES ('337', '37', null, null, '2019-03-16 10:33:33');
INSERT INTO `article_visit_log` VALUES ('338', '37', null, null, '2019-03-16 10:33:50');
INSERT INTO `article_visit_log` VALUES ('339', '37', null, null, '2019-03-16 10:34:26');
INSERT INTO `article_visit_log` VALUES ('340', '37', null, null, '2019-03-16 10:34:57');
INSERT INTO `article_visit_log` VALUES ('341', '37', null, null, '2019-03-16 10:35:52');
INSERT INTO `article_visit_log` VALUES ('342', '37', null, null, '2019-03-16 10:36:41');
INSERT INTO `article_visit_log` VALUES ('343', '39', null, null, '2019-03-16 10:37:27');
INSERT INTO `article_visit_log` VALUES ('344', '39', null, null, '2019-03-16 10:38:28');
INSERT INTO `article_visit_log` VALUES ('345', '39', null, null, '2019-03-16 10:39:15');
INSERT INTO `article_visit_log` VALUES ('346', '39', null, null, '2019-03-16 10:39:40');
INSERT INTO `article_visit_log` VALUES ('347', '39', null, null, '2019-03-16 10:40:03');
INSERT INTO `article_visit_log` VALUES ('348', '39', null, null, '2019-03-16 10:40:13');
INSERT INTO `article_visit_log` VALUES ('349', '39', null, null, '2019-03-16 10:40:56');
INSERT INTO `article_visit_log` VALUES ('350', '39', null, null, '2019-03-16 10:41:26');
INSERT INTO `article_visit_log` VALUES ('351', '39', null, null, '2019-03-16 10:42:49');
INSERT INTO `article_visit_log` VALUES ('352', '39', null, null, '2019-03-16 10:50:14');
INSERT INTO `article_visit_log` VALUES ('353', '39', null, null, '2019-03-16 10:51:10');
INSERT INTO `article_visit_log` VALUES ('354', '39', null, null, '2019-03-16 10:51:13');
INSERT INTO `article_visit_log` VALUES ('355', '39', null, null, '2019-03-16 10:51:40');
INSERT INTO `article_visit_log` VALUES ('356', '39', null, null, '2019-03-16 10:56:07');
INSERT INTO `article_visit_log` VALUES ('357', '39', null, null, '2019-03-16 10:56:21');
INSERT INTO `article_visit_log` VALUES ('358', '39', null, null, '2019-03-16 10:57:30');
INSERT INTO `article_visit_log` VALUES ('359', '39', null, null, '2019-03-16 10:58:34');
INSERT INTO `article_visit_log` VALUES ('360', '39', null, null, '2019-03-16 10:59:17');
INSERT INTO `article_visit_log` VALUES ('361', '39', null, null, '2019-03-16 10:59:31');
INSERT INTO `article_visit_log` VALUES ('362', '39', null, null, '2019-03-16 10:59:35');
INSERT INTO `article_visit_log` VALUES ('363', '39', null, null, '2019-03-16 11:00:00');
INSERT INTO `article_visit_log` VALUES ('364', '40', null, null, '2019-03-16 11:00:08');
INSERT INTO `article_visit_log` VALUES ('365', '40', null, null, '2019-03-16 11:01:38');
INSERT INTO `article_visit_log` VALUES ('366', '40', null, null, '2019-03-16 11:01:42');
INSERT INTO `article_visit_log` VALUES ('367', '40', null, null, '2019-03-16 11:02:37');
INSERT INTO `article_visit_log` VALUES ('368', '40', null, null, '2019-03-16 11:03:49');
INSERT INTO `article_visit_log` VALUES ('369', '40', null, null, '2019-03-16 11:04:26');
INSERT INTO `article_visit_log` VALUES ('370', '40', null, null, '2019-03-16 11:04:41');
INSERT INTO `article_visit_log` VALUES ('371', '40', null, null, '2019-03-16 11:04:48');
INSERT INTO `article_visit_log` VALUES ('372', '40', null, null, '2019-03-16 11:05:04');
INSERT INTO `article_visit_log` VALUES ('373', '40', null, null, '2019-03-16 11:05:13');
INSERT INTO `article_visit_log` VALUES ('374', '40', null, null, '2019-03-16 11:05:30');
INSERT INTO `article_visit_log` VALUES ('375', '40', null, null, '2019-03-16 11:06:05');
INSERT INTO `article_visit_log` VALUES ('376', '38', null, null, '2019-03-16 11:06:21');
INSERT INTO `article_visit_log` VALUES ('377', '36', null, null, '2019-03-16 11:08:39');
INSERT INTO `article_visit_log` VALUES ('378', '36', null, null, '2019-03-16 11:41:19');
INSERT INTO `article_visit_log` VALUES ('379', '36', null, null, '2019-03-16 11:43:19');
INSERT INTO `article_visit_log` VALUES ('380', '37', null, null, '2019-03-16 11:47:05');
INSERT INTO `article_visit_log` VALUES ('381', '37', null, null, '2019-03-16 11:48:54');
INSERT INTO `article_visit_log` VALUES ('382', '37', null, null, '2019-03-16 11:49:00');
INSERT INTO `article_visit_log` VALUES ('383', '37', null, null, '2019-03-16 11:51:07');
INSERT INTO `article_visit_log` VALUES ('384', '37', null, null, '2019-03-16 11:51:34');
INSERT INTO `article_visit_log` VALUES ('385', '37', null, null, '2019-03-16 11:51:42');
INSERT INTO `article_visit_log` VALUES ('386', '37', null, null, '2019-03-16 11:51:58');
INSERT INTO `article_visit_log` VALUES ('387', '37', null, null, '2019-03-16 11:52:54');
INSERT INTO `article_visit_log` VALUES ('388', '37', null, null, '2019-03-16 11:53:05');
INSERT INTO `article_visit_log` VALUES ('389', '37', null, null, '2019-03-16 11:53:20');
INSERT INTO `article_visit_log` VALUES ('390', '38', null, null, '2019-03-16 11:54:03');
INSERT INTO `article_visit_log` VALUES ('391', '38', null, null, '2019-03-16 11:54:25');
INSERT INTO `article_visit_log` VALUES ('392', '38', null, null, '2019-03-16 11:55:13');
INSERT INTO `article_visit_log` VALUES ('393', '38', null, null, '2019-03-16 11:55:48');
INSERT INTO `article_visit_log` VALUES ('394', '39', null, null, '2019-03-16 11:56:06');
INSERT INTO `article_visit_log` VALUES ('395', '39', null, null, '2019-03-16 11:56:53');
INSERT INTO `article_visit_log` VALUES ('396', '39', null, null, '2019-03-16 12:04:37');
INSERT INTO `article_visit_log` VALUES ('397', '39', null, null, '2019-03-16 12:05:15');
INSERT INTO `article_visit_log` VALUES ('398', '39', null, null, '2019-03-16 12:05:15');
INSERT INTO `article_visit_log` VALUES ('399', '37', null, null, '2019-03-16 12:18:44');
INSERT INTO `article_visit_log` VALUES ('400', '38', null, null, '2019-03-16 12:19:09');
INSERT INTO `article_visit_log` VALUES ('401', '38', null, null, '2019-03-16 12:19:47');
INSERT INTO `article_visit_log` VALUES ('402', '35', null, null, '2019-03-16 12:22:06');
INSERT INTO `article_visit_log` VALUES ('403', '37', null, null, '2019-03-16 12:25:06');
INSERT INTO `article_visit_log` VALUES ('404', '37', null, null, '2019-03-16 12:27:55');
INSERT INTO `article_visit_log` VALUES ('405', '39', null, null, '2019-03-16 12:28:24');
INSERT INTO `article_visit_log` VALUES ('406', '39', null, null, '2019-03-16 12:28:50');
INSERT INTO `article_visit_log` VALUES ('407', '37', null, null, '2019-03-16 15:17:41');
INSERT INTO `article_visit_log` VALUES ('408', '40', null, null, '2019-03-16 16:14:10');
INSERT INTO `article_visit_log` VALUES ('409', '38', null, null, '2019-03-16 16:16:47');
INSERT INTO `article_visit_log` VALUES ('410', '38', null, null, '2019-03-16 17:19:28');
INSERT INTO `article_visit_log` VALUES ('411', '38', null, null, '2019-03-16 17:20:23');
INSERT INTO `article_visit_log` VALUES ('412', '39', null, null, '2019-03-16 17:29:58');
INSERT INTO `article_visit_log` VALUES ('413', '39', null, null, '2019-03-16 17:31:50');
INSERT INTO `article_visit_log` VALUES ('414', '38', null, null, '2019-03-16 17:31:59');
INSERT INTO `article_visit_log` VALUES ('415', '39', null, null, '2019-03-16 17:32:04');
INSERT INTO `article_visit_log` VALUES ('416', '39', null, null, '2019-03-16 17:39:01');
INSERT INTO `article_visit_log` VALUES ('417', '38', null, null, '2019-03-16 17:41:13');
INSERT INTO `article_visit_log` VALUES ('418', '39', null, null, '2019-03-16 17:41:26');
INSERT INTO `article_visit_log` VALUES ('419', '39', null, null, '2019-03-16 17:42:33');
INSERT INTO `article_visit_log` VALUES ('420', '38', null, null, '2019-03-16 17:42:33');
INSERT INTO `article_visit_log` VALUES ('421', '34', null, null, '2019-03-16 17:43:02');
INSERT INTO `article_visit_log` VALUES ('422', '34', null, null, '2019-03-16 17:43:34');
INSERT INTO `article_visit_log` VALUES ('423', '39', null, null, '2019-03-16 17:43:34');
INSERT INTO `article_visit_log` VALUES ('424', '38', null, null, '2019-03-16 17:43:34');
INSERT INTO `article_visit_log` VALUES ('425', '40', null, null, '2019-03-16 17:43:43');
INSERT INTO `article_visit_log` VALUES ('426', '40', null, null, '2019-03-16 17:43:59');
INSERT INTO `article_visit_log` VALUES ('427', '34', null, null, '2019-03-16 17:44:15');
INSERT INTO `article_visit_log` VALUES ('428', '35', null, null, '2019-03-16 17:46:44');
INSERT INTO `article_visit_log` VALUES ('429', '35', null, null, '2019-03-16 17:47:02');
INSERT INTO `article_visit_log` VALUES ('430', '39', null, null, '2019-03-16 19:56:44');
INSERT INTO `article_visit_log` VALUES ('431', '35', null, null, '2019-03-16 20:16:53');
INSERT INTO `article_visit_log` VALUES ('432', '38', null, null, '2019-03-16 20:17:06');
INSERT INTO `article_visit_log` VALUES ('433', '38', null, null, '2019-03-16 21:04:35');
INSERT INTO `article_visit_log` VALUES ('434', '38', null, null, '2019-03-16 22:46:31');
INSERT INTO `article_visit_log` VALUES ('435', '38', null, null, '2019-03-16 22:50:11');
INSERT INTO `article_visit_log` VALUES ('436', '39', null, null, '2019-03-16 22:53:21');
INSERT INTO `article_visit_log` VALUES ('437', '38', null, null, '2019-03-17 00:34:10');
INSERT INTO `article_visit_log` VALUES ('438', '38', null, null, '2019-03-17 09:32:42');
INSERT INTO `article_visit_log` VALUES ('439', '38', null, null, '2019-03-17 11:16:29');
INSERT INTO `article_visit_log` VALUES ('440', '38', null, null, '2019-03-17 11:17:03');
INSERT INTO `article_visit_log` VALUES ('441', '36', null, null, '2019-03-17 11:17:12');
INSERT INTO `article_visit_log` VALUES ('442', '38', null, null, '2019-03-17 11:21:11');
INSERT INTO `article_visit_log` VALUES ('443', '31', null, null, '2019-03-17 11:21:31');
INSERT INTO `article_visit_log` VALUES ('444', '38', null, null, '2019-03-17 11:47:26');
INSERT INTO `article_visit_log` VALUES ('445', '38', null, null, '2019-03-17 11:49:24');
INSERT INTO `article_visit_log` VALUES ('446', '38', null, null, '2019-03-17 11:49:56');
INSERT INTO `article_visit_log` VALUES ('447', '30', null, null, '2019-03-17 11:57:57');
INSERT INTO `article_visit_log` VALUES ('448', '38', null, null, '2019-03-17 12:03:16');
INSERT INTO `article_visit_log` VALUES ('449', '32', null, null, '2019-03-17 12:05:24');
INSERT INTO `article_visit_log` VALUES ('450', '33', null, null, '2019-03-17 12:05:34');
INSERT INTO `article_visit_log` VALUES ('451', '34', null, null, '2019-03-17 12:05:39');
INSERT INTO `article_visit_log` VALUES ('452', '33', null, null, '2019-03-17 12:05:40');
INSERT INTO `article_visit_log` VALUES ('453', '32', null, null, '2019-03-17 12:05:42');
INSERT INTO `article_visit_log` VALUES ('454', '38', null, null, '2019-03-17 12:59:03');
INSERT INTO `article_visit_log` VALUES ('455', '38', null, null, '2019-03-17 13:05:37');
INSERT INTO `article_visit_log` VALUES ('456', '38', null, null, '2019-03-17 13:09:22');
INSERT INTO `article_visit_log` VALUES ('457', '37', null, null, '2019-03-17 13:49:13');
INSERT INTO `article_visit_log` VALUES ('458', '38', null, null, '2019-03-17 14:41:19');
INSERT INTO `article_visit_log` VALUES ('459', '40', null, null, '2019-03-17 21:19:11');
INSERT INTO `article_visit_log` VALUES ('460', '40', null, null, '2019-03-17 21:19:19');
INSERT INTO `article_visit_log` VALUES ('461', '30', null, null, '2019-03-17 21:20:02');
INSERT INTO `article_visit_log` VALUES ('462', '39', null, null, '2019-03-17 21:24:22');
INSERT INTO `article_visit_log` VALUES ('463', '38', null, null, '2019-03-17 21:24:28');
INSERT INTO `article_visit_log` VALUES ('464', '37', null, null, '2019-03-17 21:24:35');
INSERT INTO `article_visit_log` VALUES ('465', '39', null, null, '2019-03-17 21:24:45');
INSERT INTO `article_visit_log` VALUES ('466', '34', null, null, '2019-03-17 21:26:51');
INSERT INTO `article_visit_log` VALUES ('467', '40', null, null, '2019-03-17 22:39:37');
INSERT INTO `article_visit_log` VALUES ('468', '38', null, null, '2019-03-18 20:46:38');
INSERT INTO `article_visit_log` VALUES ('469', '38', null, null, '2019-03-18 22:12:12');
INSERT INTO `article_visit_log` VALUES ('470', '38', null, null, '2019-03-18 22:49:42');
INSERT INTO `article_visit_log` VALUES ('471', '35', null, null, '2019-03-18 23:25:01');
INSERT INTO `article_visit_log` VALUES ('472', '39', null, null, '2019-03-18 23:47:34');
INSERT INTO `article_visit_log` VALUES ('473', '33', null, null, '2019-03-18 23:47:37');
INSERT INTO `article_visit_log` VALUES ('474', '28', null, null, '2019-03-18 23:51:19');
INSERT INTO `article_visit_log` VALUES ('475', '40', null, null, '2019-03-19 09:03:20');
INSERT INTO `article_visit_log` VALUES ('476', '37', null, null, '2019-03-19 11:01:11');
INSERT INTO `article_visit_log` VALUES ('477', '38', null, null, '2019-03-19 12:46:12');
INSERT INTO `article_visit_log` VALUES ('478', '40', null, null, '2019-03-19 19:12:53');
INSERT INTO `article_visit_log` VALUES ('479', '38', null, null, '2019-03-19 19:35:34');
INSERT INTO `article_visit_log` VALUES ('480', '38', null, null, '2019-03-19 23:01:59');
INSERT INTO `article_visit_log` VALUES ('481', '38', null, null, '2019-03-19 23:03:56');
INSERT INTO `article_visit_log` VALUES ('482', '20', null, null, '2019-03-20 16:23:17');
INSERT INTO `article_visit_log` VALUES ('483', '38', null, null, '2019-03-20 19:35:04');
INSERT INTO `article_visit_log` VALUES ('484', '36', null, null, '2019-03-20 19:42:22');
INSERT INTO `article_visit_log` VALUES ('485', '36', null, null, '2019-03-20 19:43:43');
INSERT INTO `article_visit_log` VALUES ('486', '36', null, null, '2019-03-20 19:44:19');
INSERT INTO `article_visit_log` VALUES ('487', '36', null, null, '2019-03-20 19:44:48');
INSERT INTO `article_visit_log` VALUES ('488', '39', null, null, '2019-03-20 19:57:36');
INSERT INTO `article_visit_log` VALUES ('489', '38', null, null, '2019-03-20 21:12:32');
INSERT INTO `article_visit_log` VALUES ('490', '35', null, null, '2019-03-20 21:18:24');
INSERT INTO `article_visit_log` VALUES ('491', '40', null, null, '2019-03-20 23:33:35');
INSERT INTO `article_visit_log` VALUES ('492', '38', null, null, '2019-03-21 00:01:00');
INSERT INTO `article_visit_log` VALUES ('493', '38', null, null, '2019-03-21 00:02:37');
INSERT INTO `article_visit_log` VALUES ('494', '35', null, null, '2019-03-21 07:13:38');
INSERT INTO `article_visit_log` VALUES ('495', '38', null, null, '2019-03-21 07:14:05');
INSERT INTO `article_visit_log` VALUES ('496', '38', null, null, '2019-03-21 10:57:07');
INSERT INTO `article_visit_log` VALUES ('497', '34', null, null, '2019-03-21 11:05:55');
INSERT INTO `article_visit_log` VALUES ('498', '34', null, null, '2019-03-21 11:06:08');
INSERT INTO `article_visit_log` VALUES ('499', '35', null, null, '2019-03-21 11:06:56');
INSERT INTO `article_visit_log` VALUES ('500', '36', null, null, '2019-03-21 11:07:01');
INSERT INTO `article_visit_log` VALUES ('501', '39', null, null, '2019-03-21 11:07:52');
INSERT INTO `article_visit_log` VALUES ('502', '38', null, null, '2019-03-21 11:08:31');
INSERT INTO `article_visit_log` VALUES ('503', '38', null, null, '2019-03-21 11:11:32');
INSERT INTO `article_visit_log` VALUES ('504', '38', null, null, '2019-03-21 11:12:54');
INSERT INTO `article_visit_log` VALUES ('505', '29', null, null, '2019-03-21 12:23:05');
INSERT INTO `article_visit_log` VALUES ('506', '38', null, null, '2019-03-21 12:23:20');
INSERT INTO `article_visit_log` VALUES ('507', '38', null, null, '2019-03-21 19:54:06');
INSERT INTO `article_visit_log` VALUES ('508', '37', null, null, '2019-03-21 19:54:22');
INSERT INTO `article_visit_log` VALUES ('509', '35', null, null, '2019-03-21 19:54:35');
INSERT INTO `article_visit_log` VALUES ('510', '38', null, null, '2019-03-21 22:01:53');
INSERT INTO `article_visit_log` VALUES ('511', '38', null, null, '2019-03-21 22:12:06');
INSERT INTO `article_visit_log` VALUES ('512', '38', null, null, '2019-03-21 22:13:09');
INSERT INTO `article_visit_log` VALUES ('513', '38', null, null, '2019-03-21 22:14:41');
INSERT INTO `article_visit_log` VALUES ('514', '39', null, null, '2019-03-21 22:14:48');
INSERT INTO `article_visit_log` VALUES ('515', '38', null, null, '2019-03-21 22:17:10');
INSERT INTO `article_visit_log` VALUES ('516', '38', null, null, '2019-03-23 10:00:30');
INSERT INTO `article_visit_log` VALUES ('517', '38', null, null, '2019-03-23 13:17:21');
INSERT INTO `article_visit_log` VALUES ('518', '38', null, null, '2019-03-23 13:20:44');
INSERT INTO `article_visit_log` VALUES ('519', '38', null, null, '2019-03-23 13:21:01');
INSERT INTO `article_visit_log` VALUES ('520', '38', null, null, '2019-03-23 13:21:41');
INSERT INTO `article_visit_log` VALUES ('521', '38', null, null, '2019-03-23 13:21:45');
INSERT INTO `article_visit_log` VALUES ('522', '39', null, null, '2019-03-23 13:26:40');
INSERT INTO `article_visit_log` VALUES ('523', '38', null, null, '2019-03-23 13:30:11');
INSERT INTO `article_visit_log` VALUES ('524', '39', null, null, '2019-03-23 13:30:11');
INSERT INTO `article_visit_log` VALUES ('525', '38', null, null, '2019-03-23 13:30:32');
INSERT INTO `article_visit_log` VALUES ('526', '39', null, null, '2019-03-23 13:30:41');
INSERT INTO `article_visit_log` VALUES ('527', '39', null, null, '2019-03-23 13:30:47');
INSERT INTO `article_visit_log` VALUES ('528', '38', null, null, '2019-03-23 13:30:47');
INSERT INTO `article_visit_log` VALUES ('529', '38', null, null, '2019-03-23 13:32:39');
INSERT INTO `article_visit_log` VALUES ('530', '39', null, null, '2019-03-23 13:32:41');
INSERT INTO `article_visit_log` VALUES ('531', '40', null, null, '2019-03-23 13:33:34');
INSERT INTO `article_visit_log` VALUES ('532', '39', null, null, '2019-03-23 13:35:07');
INSERT INTO `article_visit_log` VALUES ('533', '40', null, null, '2019-03-23 13:35:31');
INSERT INTO `article_visit_log` VALUES ('534', '40', null, null, '2019-03-23 13:36:03');
INSERT INTO `article_visit_log` VALUES ('535', '32', null, null, '2019-03-23 13:38:39');
INSERT INTO `article_visit_log` VALUES ('536', '38', null, null, '2019-03-23 13:47:43');
INSERT INTO `article_visit_log` VALUES ('537', '39', null, null, '2019-03-23 14:01:06');
INSERT INTO `article_visit_log` VALUES ('538', '38', null, null, '2019-03-23 14:18:32');
INSERT INTO `article_visit_log` VALUES ('539', '40', null, null, '2019-03-23 14:19:03');
INSERT INTO `article_visit_log` VALUES ('540', '37', null, null, '2019-03-23 14:19:40');
INSERT INTO `article_visit_log` VALUES ('541', '37', null, null, '2019-03-23 14:19:51');
INSERT INTO `article_visit_log` VALUES ('542', '37', null, null, '2019-03-23 14:22:17');
INSERT INTO `article_visit_log` VALUES ('543', '37', null, null, '2019-03-23 14:23:23');
INSERT INTO `article_visit_log` VALUES ('544', '33', null, null, '2019-03-23 14:24:28');
INSERT INTO `article_visit_log` VALUES ('545', '35', null, null, '2019-03-23 14:26:57');
INSERT INTO `article_visit_log` VALUES ('546', '36', null, null, '2019-03-23 14:27:07');
INSERT INTO `article_visit_log` VALUES ('547', '33', null, null, '2019-03-23 14:34:07');
INSERT INTO `article_visit_log` VALUES ('548', '33', null, null, '2019-03-23 14:36:34');
INSERT INTO `article_visit_log` VALUES ('549', '36', null, null, '2019-03-23 14:49:14');
INSERT INTO `article_visit_log` VALUES ('550', '36', null, null, '2019-03-23 14:50:33');
INSERT INTO `article_visit_log` VALUES ('551', '33', null, null, '2019-03-23 14:55:11');
INSERT INTO `article_visit_log` VALUES ('552', '34', null, null, '2019-03-23 14:55:26');
INSERT INTO `article_visit_log` VALUES ('553', '33', null, null, '2019-03-23 14:55:37');
INSERT INTO `article_visit_log` VALUES ('554', '37', null, null, '2019-03-23 15:08:37');
INSERT INTO `article_visit_log` VALUES ('555', '38', null, null, '2019-03-23 17:37:09');
INSERT INTO `article_visit_log` VALUES ('556', '34', null, null, '2019-03-23 18:22:21');
INSERT INTO `article_visit_log` VALUES ('557', '35', null, null, '2019-03-23 18:22:30');
INSERT INTO `article_visit_log` VALUES ('558', '35', null, null, '2019-03-23 18:23:19');
INSERT INTO `article_visit_log` VALUES ('559', '35', null, null, '2019-03-23 18:29:07');
INSERT INTO `article_visit_log` VALUES ('560', '35', null, null, '2019-03-23 18:30:23');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('7', 'Java', 'Java', '2019-03-05 22:11:36', '2019-03-05 22:11:36');
INSERT INTO `category` VALUES ('8', 'Spring', 'Spring', '2019-03-05 22:11:45', '2019-03-05 22:11:45');
INSERT INTO `category` VALUES ('9', 'SpringBoot', 'Springboot', '2019-03-05 22:11:57', '2019-03-05 22:11:57');

-- ----------------------------
-- Table structure for child_comment
-- ----------------------------
DROP TABLE IF EXISTS `child_comment`;
CREATE TABLE `child_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) DEFAULT NULL COMMENT '文章id',
  `origin_id` varchar(255) DEFAULT NULL COMMENT '楼主id',
  `pid` varchar(255) DEFAULT NULL COMMENT '父id',
  `cid` varchar(255) DEFAULT NULL COMMENT '子id',
  `content` varchar(255) DEFAULT NULL COMMENT '内容',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of child_comment
-- ----------------------------

-- ----------------------------
-- Table structure for comments
-- ----------------------------
DROP TABLE IF EXISTS `comments`;
CREATE TABLE `comments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `article_id` bigint(20) DEFAULT NULL COMMENT '文章id',
  `user_id` varchar(255) DEFAULT NULL COMMENT '用户id',
  `user_name` varchar(255) DEFAULT NULL COMMENT '用户 名',
  `avatar` varchar(500) DEFAULT NULL COMMENT '头像地址',
  `content` varchar(500) DEFAULT NULL COMMENT '评论内容',
  `create_time` datetime DEFAULT NULL COMMENT '评论时间',
  `children` text COMMENT '子评论',
  `status` tinyint(4) DEFAULT NULL COMMENT '状态',
  `is_top` tinyint(4) DEFAULT NULL COMMENT '是否置顶',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of comments
-- ----------------------------
INSERT INTO `comments` VALUES ('1', '37', 'a57064ef08ee4a61a76f45fc34849527', 'xbmchina', null, 'gggggggggggggg', '2019-03-16 11:47:13', '[{\"content\":\"jiushuo\",\"createTime\":1552708052564,\"favatar\":\"\",\"fid\":\"def34735a54e4406b5d4b6e3416e84c2\",\"fusername\":\"hehe\",\"tid\":\"a57064ef08ee4a61a76f45fc34849527\",\"tusername\":\"xbmchina\"},{\"content\":\"xixixi\",\"createTime\":1552708105595,\"favatar\":\"\",\"fid\":\"a57064ef08ee4a61a76f45fc34849527\",\"fusername\":\"xbmchina\",\"tavatar\":\"\",\"tid\":\"def34735a54e4406b5d4b6e3416e84c2\",\"tusername\":\"hehe\"},{\"content\":\"你两去死吧\\n\",\"createTime\":1552708210954,\"favatar\":\"\",\"fid\":\"ab29ab1bef724faabe86d348854c55ae\",\"fusername\":\"zero10\",\"tavatar\":\"\",\"tid\":\"a57064ef08ee4a61a76f45fc34849527\",\"tusername\":\"xbmchina\"}]', null, null);
INSERT INTO `comments` VALUES ('2', '37', 'ab29ab1bef724faabe86d348854c55ae', 'zero10', null, '就骂你', '2019-03-16 11:53:27', '[{\"content\":\"55555555555\",\"createTime\":1552708417136,\"favatar\":\"\",\"fid\":\"ab29ab1bef724faabe86d348854c55ae\",\"fusername\":\"zero10\",\"tid\":\"ab29ab1bef724faabe86d348854c55ae\",\"tusername\":\"zero10\"}]', null, null);
INSERT INTO `comments` VALUES ('3', '39', 'ab29ab1bef724faabe86d348854c55ae', 'zero10', null, '哒哒哒哒哒哒多多多', '2019-03-16 11:57:00', '[{\"content\":\"855555555555\",\"createTime\":1552708755557,\"favatar\":\"\",\"fid\":\"ab29ab1bef724faabe86d348854c55ae\",\"fusername\":\"zero10\",\"tid\":\"ab29ab1bef724faabe86d348854c55ae\",\"tusername\":\"zero10\"},{\"content\":\"555555555\",\"createTime\":1552709095797,\"favatar\":\"\",\"fid\":\"ab29ab1bef724faabe86d348854c55ae\",\"fusername\":\"zero10\",\"tavatar\":\"\",\"tid\":\"ab29ab1bef724faabe86d348854c55ae\",\"tusername\":\"zero10\"},{\"content\":\"8787465456\",\"createTime\":1552709158081,\"favatar\":\"\",\"fid\":\"a57064ef08ee4a61a76f45fc34849527\",\"fusername\":\"xbmchina\",\"tavatar\":\"\",\"tid\":\"ab29ab1bef724faabe86d348854c55ae\",\"tusername\":\"zero10\"}]', null, null);
INSERT INTO `comments` VALUES ('4', '39', 'ab29ab1bef724faabe86d348854c55ae', 'zero10', null, '888888888888', '2019-03-16 12:04:45', null, null, null);
INSERT INTO `comments` VALUES ('5', '38', 'a57064ef08ee4a61a76f45fc34849527', 'xbmchina', null, 'xiixxiixi', '2019-03-16 12:21:46', null, null, null);
INSERT INTO `comments` VALUES ('6', '35', 'a57064ef08ee4a61a76f45fc34849527', 'xbmchina', null, 'dfsgsdgsdg', '2019-03-16 12:22:12', null, null, null);
INSERT INTO `comments` VALUES ('7', '38', 'a57064ef08ee4a61a76f45fc34849527', 'xbmchina', null, '不错', '2019-03-16 16:17:09', null, null, null);
INSERT INTO `comments` VALUES ('8', '30', 'a57064ef08ee4a61a76f45fc34849527', 'xbmchina', null, 'bucuo', '2019-03-17 21:20:28', null, null, null);
INSERT INTO `comments` VALUES ('9', '38', '6d960d71827f46019af5ed64270ce179', '宝宝明', null, '很棒棒的文章，我很喜欢', '2019-03-21 11:12:29', null, null, null);
INSERT INTO `comments` VALUES ('10', '38', 'a57064ef08ee4a61a76f45fc34849527', 'xbmchina', null, 'hhh', '2019-03-23 17:51:50', null, null, null);

-- ----------------------------
-- Table structure for message
-- ----------------------------
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `user_id` varchar(255) DEFAULT NULL COMMENT '留言用户',
  `content` varchar(500) DEFAULT NULL COMMENT '留言内容',
  `status` tinyint(2) DEFAULT NULL COMMENT '审核是否通过：0：通过；1不通过',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of message
-- ----------------------------
INSERT INTO `message` VALUES ('1', '1131663064@qq.com', 'a57064ef08ee4a61a76f45fc34849527', '胜多负少的是发送到', null, null, null);
INSERT INTO `message` VALUES ('2', '13652878074@163.com', 'a57064ef08ee4a61a76f45fc34849527', 'sdfdsfdsfsd', null, '2019-03-16 17:16:56', '2019-03-16 17:16:56');
INSERT INTO `message` VALUES ('3', '1131663064@qq.com', 'a57064ef08ee4a61a76f45fc34849527', '不错呦', null, '2019-03-23 18:06:31', '2019-03-23 18:06:31');

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES ('1', 'ROLE_ADMIN');
INSERT INTO `role` VALUES ('2', 'ROLE_USER');

-- ----------------------------
-- Table structure for sonart
-- ----------------------------
DROP TABLE IF EXISTS `sonart`;
CREATE TABLE `sonart` (
  `sonid` int(11) NOT NULL AUTO_INCREMENT,
  `soncontent` text,
  `username` varchar(32) NOT NULL COMMENT '评论人',
  `viewTime` datetime DEFAULT NULL,
  `faid` int(10) NOT NULL,
  PRIMARY KEY (`sonid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sonart
-- ----------------------------

-- ----------------------------
-- Table structure for special
-- ----------------------------
DROP TABLE IF EXISTS `special`;
CREATE TABLE `special` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL COMMENT '专栏名称',
  `detail` varchar(500) DEFAULT NULL COMMENT '专栏简介',
  `img` varchar(255) DEFAULT NULL COMMENT '专栏图片',
  `uid` bigint(20) DEFAULT NULL COMMENT '用户id',
  `remark` varchar(255) DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of special
-- ----------------------------
INSERT INTO `special` VALUES ('6', 'Java', 'JavaEE和JavaSE', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);
INSERT INTO `special` VALUES ('7', 'Spring', 'SpringBoot和Spring', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);
INSERT INTO `special` VALUES ('8', 'SpringClound', 'SpringClound', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);
INSERT INTO `special` VALUES ('9', 'Netty', 'Netty4.x相关知识', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);
INSERT INTO `special` VALUES ('10', 'Spark', '大数据Spark', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);
INSERT INTO `special` VALUES ('12', '数据库', '针对mysql和oracle数据库知识', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);
INSERT INTO `special` VALUES ('13', 'Hadoop', 'Hadoop家族', 'https://upload-images.jianshu.io/upload_images/13150128-a65b8a3f64ed4a25.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000/format/webp', null, null, null);

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL COMMENT '标签名',
  `desc` varchar(255) DEFAULT NULL COMMENT '标签描述',
  `icon` varchar(255) DEFAULT NULL COMMENT '标签图标',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of tag
-- ----------------------------

-- ----------------------------
-- Table structure for time_axis
-- ----------------------------
DROP TABLE IF EXISTS `time_axis`;
CREATE TABLE `time_axis` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL COMMENT '时间轴节点标题',
  `content` varchar(255) DEFAULT NULL COMMENT '时间轴内容',
  `status` tinyint(2) DEFAULT NULL COMMENT '状态',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `create_time` datetime DEFAULT NULL,
  `update_time` datetime DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of time_axis
-- ----------------------------

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `sex` varchar(4) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL COMMENT 'ip地址',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `last_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `activated` tinyint(4) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('067e023d4958449980f6aaeac1a8bc89', 'bububu', '$2a$10$lKsjck43IXvYNmWe34gg..CAvkW14AlpMpf6QdpPmoLZuELo0nY2C', null, null, null, null, null, null, '127.0.0.1', '2019-03-17 12:59:20', '2019-03-17 12:59:27', '1');
INSERT INTO `user` VALUES ('1', 'zero', '$10$uT3KokcVP5FgUY7J4gg8pu6qNT7GNF0miGASKlN2m40cr1HjRr9ny', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `user` VALUES ('2', 'sally', '123456', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `user` VALUES ('26dbf7ea33474c01a4abde351bfaf2f9', 'bilibil', '12345', null, null, null, null, null, null, null, null, null, null);
INSERT INTO `user` VALUES ('324fdbae1fd349dab198c0c81cd17dc8', '嘻嘻嘻嘻嘻嘻嘻嘻寻寻寻寻寻寻寻寻寻寻寻寻', '$2a$10$RMY91Sa/dZqiVa2kNlUE9.QHLD267EcLrk/fn3tXqpwcveAftytl2', null, null, null, null, null, null, '192.168.11.138', '2019-03-08 20:49:03', '2019-03-08 20:49:13', '1');
INSERT INTO `user` VALUES ('34c3b52e5b80480d81b7c460f6b56fc6', 'xbm', '$2a$10$xfJxG/.t/xJ19KFQOG8QYeNzLFFI/PNpJOm1lDDxD7NOy0HPEJe8m', null, null, null, null, null, null, '0:0:0:0:0:0:0:1', '2019-03-08 17:17:30', '2019-03-09 22:58:29', '1');
INSERT INTO `user` VALUES ('6d960d71827f46019af5ed64270ce179', '宝宝明', '$2a$10$6vRKGKfCZHfTG50V5jkyb.NgChG4asmXOfBFN97Fsjxg99OLz4/HK', null, null, null, null, null, null, '127.0.0.1', '2019-03-21 11:12:03', '2019-03-21 11:12:10', '1');
INSERT INTO `user` VALUES ('799779e4472a4cc385b679cce082ac6e', 'wbd', '12345', null, null, null, null, null, null, '0:0:0:0:0:0:0:1', '2019-03-08 17:13:37', '2019-03-08 17:13:37', null);
INSERT INTO `user` VALUES ('87e04b702e464561ae29c2ce6262311d', 'zero12', '$2a$10$bh/bmb6YSVyMBebCG.UAFOreIHnmfJNksAHsdg.fqiGAP/4UCsWYm', null, null, null, null, null, null, '192.168.11.138', '2019-03-10 13:32:14', '2019-03-10 13:32:14', '1');
INSERT INTO `user` VALUES ('a57064ef08ee4a61a76f45fc34849527', 'xbmchina', '$2a$10$uT3KokcVP5FgUY7J4gg8pu6qNT7GNF0miGASKlN2m40cr1HjRr9ny', null, null, null, null, null, null, '192.168.11.138', '2019-03-08 19:30:55', '2019-03-23 18:31:00', '1');
INSERT INTO `user` VALUES ('ab29ab1bef724faabe86d348854c55ae', 'zero10', '$2a$10$f9s39Qb4G3z4stQKl9cYIOQI/Ac3F6kATJC9q4PxWDi.cn.VBtwfu', null, null, null, null, null, null, '192.168.11.138', '2019-03-10 13:32:09', '2019-03-16 11:50:02', '1');
INSERT INTO `user` VALUES ('b56b33f9264945e6b35fc159c09961dd', '123213', '$2a$10$ArU3hCU7LZ958ONpUdUunOnE5GTuoGUabs8cpxvU0jhZTF12a8olq', null, null, null, null, null, null, '192.168.11.138', '2019-03-17 12:38:25', '2019-03-17 12:38:34', '1');
INSERT INTO `user` VALUES ('bb7ce197d8ce4bf2962c34af7925e2b5', 'zero13', '$2a$10$q4rW8q2dd2prQVwKvsc7nOwjTkwq5yMLghQydMOsaZBkOwQSbUuKy', null, null, null, null, null, null, '192.168.11.138', '2019-03-10 13:33:12', '2019-03-10 13:33:12', '1');
INSERT INTO `user` VALUES ('d193637d1b494e74b2d3e06b8cc6c720', '恩恩额', '$2a$10$Cs4STLVE2ihJso9z8sI/oepWmHx15IQGFYAFG6NP1qRQWNGA99rGC', null, null, null, null, null, null, '127.0.0.1', '2019-03-21 00:01:23', '2019-03-21 00:01:41', '1');
INSERT INTO `user` VALUES ('def34735a54e4406b5d4b6e3416e84c2', 'hehe', '$2a$10$E88/GlHzeZZXdVgKY1Cvvello5YpnkWOC7AcBCYkBIZoSAVdj0CsS', null, null, null, null, null, null, '0:0:0:0:0:0:0:1', '2019-03-08 17:37:44', '2019-03-16 11:47:26', '1');
INSERT INTO `user` VALUES ('f90db91f0a7142eebcc4d33520d6bc09', 'zer01', '$2a$10$q7gMA0GEPei1Lmz0DiaXJuOWT5AOxfnC05855kf7VDb5rVF5J4WhK', null, null, null, null, null, null, '192.168.11.138', '2019-03-10 13:35:15', '2019-03-10 13:35:30', '1');
INSERT INTO `user` VALUES ('fa66bea8295f46c089edf793015b5f67', 'xbmchinaxbmchina', '$2a$10$hQ5wEZi.RAZcLQmeLpwxueHJO/iSzmi9NB1GZM9unY5JWlZaCoOtm', null, null, null, null, null, null, '192.168.11.138', '2019-03-09 19:48:42', '2019-03-09 20:14:49', '1');

-- ----------------------------
-- Table structure for user_role
-- ----------------------------
DROP TABLE IF EXISTS `user_role`;
CREATE TABLE `user_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) DEFAULT NULL,
  `role_id` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user_role
-- ----------------------------
INSERT INTO `user_role` VALUES ('1', '1', '1');
INSERT INTO `user_role` VALUES ('40', '26dbf7ea33474c01a4abde351bfaf2f9', '2');
INSERT INTO `user_role` VALUES ('41', '799779e4472a4cc385b679cce082ac6e', '2');
INSERT INTO `user_role` VALUES ('42', '34c3b52e5b80480d81b7c460f6b56fc6', '2');
INSERT INTO `user_role` VALUES ('43', 'def34735a54e4406b5d4b6e3416e84c2', '2');
INSERT INTO `user_role` VALUES ('44', 'a57064ef08ee4a61a76f45fc34849527', '1');
INSERT INTO `user_role` VALUES ('45', '324fdbae1fd349dab198c0c81cd17dc8', '2');
INSERT INTO `user_role` VALUES ('46', 'fa66bea8295f46c089edf793015b5f67', '2');
INSERT INTO `user_role` VALUES ('47', 'ab29ab1bef724faabe86d348854c55ae', '2');
INSERT INTO `user_role` VALUES ('48', '87e04b702e464561ae29c2ce6262311d', '2');
INSERT INTO `user_role` VALUES ('49', 'bb7ce197d8ce4bf2962c34af7925e2b5', '2');
INSERT INTO `user_role` VALUES ('50', 'f90db91f0a7142eebcc4d33520d6bc09', '2');
INSERT INTO `user_role` VALUES ('51', 'b56b33f9264945e6b35fc159c09961dd', '2');
INSERT INTO `user_role` VALUES ('52', '067e023d4958449980f6aaeac1a8bc89', '2');
INSERT INTO `user_role` VALUES ('53', 'd193637d1b494e74b2d3e06b8cc6c720', '2');
INSERT INTO `user_role` VALUES ('54', '6d960d71827f46019af5ed64270ce179', '2');

-- ----------------------------
-- Table structure for visit_log
-- ----------------------------
DROP TABLE IF EXISTS `visit_log`;
CREATE TABLE `visit_log` (
  `id` bigint(20) NOT NULL,
  `ip_address` varchar(255) DEFAULT NULL COMMENT '访问ip',
  `visit_time` datetime DEFAULT NULL COMMENT '访问的时间',
  `user_id` varchar(255) DEFAULT NULL COMMENT '用户id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of visit_log
-- ----------------------------
