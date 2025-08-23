## 基本技术术语解释

### LLM（大语言模型）：

通过海量文本训练的超大规模深度学习模型（如GPT-4、Claude、Llama等），能够理解和生成自然语言，具备文本生成、问答、翻译等能力。

###  **RAG**（检索增强生成）

通过**检索外部知识库**来增强LLM生成结果的技术。先检索相关文档片段，再将其作为上下文输入LLM生成答案。

### **LangChain框架**

[LangChain 框架介绍 | 🦜️🔗 Langchain](https://docs.langchain.com.cn/docs/introduction/)

一个用于构建**基于LLM的应用程序**的开发框架，提供模块化工具链（如记忆管理、工具调用、多步骤工作流）。

核心组件如下：

- 模型（Models）：包含各大语言模型的 LangChain 接口和调用细节，以及输出解析机制。

- 提示模版（Prompts）：使提请示工程流程化，进一步激发大语言模型的潜力。

- 数据检索（Indexes）：构建并操作文档的方法，接收用户的查询并返回最相关的文档，轻松搭建本地知识库。

- 记忆（Memory）：通过短时记忆和长时记忆，在对话过程中存储和检索数据，让 ChatBot 记住你。

- 链（Chains）：LangChain 中的核心机制，以特定方式封装各种功能，并通过一系列的组合，自动而灵活地完成任务。

- 代理（Agents）：另一个 LangChain 的核心机制，通过“代理”让大模型自由调用外部工具和内部工具，使智能 Agent 成为可能。

开源库组成：

- langchain-core：基础抽象和LangChain表达式语言
- langchain-community：第三方集成，合作伙伴包（如langchain-openai、langchain-anthropic等）——一些集成已经进一步拆分为自己的轻量级包，只依赖于langchain-core
- langchain：构成应用程序认知架构的链、代理和检索策略
- langgraph：通过将链组装成图中的边和节点，使用 LLMS 构建健壮且有状态的多参与者应用程序
- langserve：将 LangChain 链部署为 REST API
- LangSmith：一个开发者平台，可以让您调试、测试、评估和监控 LLM 应用程序，并与 LangChain 无缝集成

### **Agent（智能代理）**

基于LLM的自主决策系统，通过**调用工具（Tools）**完成复杂任务（如计算、搜索、代码执行）。

### 总结

- **LLM**：底层核心模型，负责语言理解和生成。
- **RAG**：为LLM注入实时/领域知识的技术。
- **LangChain**：快速搭建LLM应用的“脚手架”。
- **Agent**：让LLM具备自主决策和行动能力的智能体。

## 开发环境准备

python环境、使用pip或cudo安装langchain、jupyter、openai（1.0版本以上）。

使用vscode打开.ipynb文件，然后安装jupyter插件。

```bash
pip install openai
```

修改pip的镜像

```
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
```

**硅基流动网站以及模型**

[模型广场 - SiliconCloud](https://cloud.siliconflow.cn/sft-u0wikroi0z/models)

[快速上手 - SiliconFlow](https://docs.siliconflow.cn/cn/userguide/quickstart)

#### 调用大语言模型api的基本代码

```python
import os
from langchain.llms import OpenAI
# 设置环境变量
os.environ["OPENAI_API_KEY"] = "sk-gpmmzhmykobgrypnecrzdqqdfxnwxaoevtqxrxcqbftpmync"
os.environ["OPENAI_API_BASE"] = "https://api.siliconflow.cn"  # 如果使用代理
# 初始化LLM
llm = OpenAI(
    model_name="Qwen/Qwen3-8B",
    temperature=0.9,
)

# 调用模型
response = llm("请解释量子计算")
print(response)
```

#### OpenAI里的其它参数介绍

**`model_name`：**指定使用的模型版本（如 `gpt-3.5-turbo`、`gpt-4`）。

**`max_tokens`：**限制生成内容的最大 token 数量（1 token ≈ 1个英文单词或 2-3个中文字）。

**`top_p`（核采样）：**从累积概率超过 `top_p` 的候选词中随机选择，控制多样性（与 `temperature` 二选一）。

- `top_p=0.9`：从概率最高的 90% 词中选择。

- `top_p=0.1`：结果更确定。

**`frequency_penalty` 和 `presence_penalty`**

- `frequency_penalty`（-2.0~2.0）：抑制重复出现的词（值越大越避免重复）。
- `presence_penalty`（-2.0~2.0）：抑制已提到的主题（值越大越倾向新内容）。

**`stop`**：指定停止生成的标记（如遇到特定词时终止输出）。

- **示例**：

  ```py
  llm = OpenAI(stop=["\n", "。"])  # 遇到换行符或句号时停止
  ```

**`n`**：生成多个候选回答（返回列表）。

**`best_of`**：生成多个回答并返回质量最高的一个（消耗更多 token）。

**`logit_bias`**：调整特定 token 的生成概率（精确控制敏感词）。

**`openai_api_key` 和 `openai_api_base`**：覆盖环境变量中的 API 密钥和代理地址。

 **`request_timeout`**：设置 API 请求超时时间（秒）。



## 提示词工程prompts

### **优秀的提示词：** 

【立角色】：引导AI进入具体场景，赋予其行家身份 

【述问题】：告诉AI你的困惑和问题，以及背景信息 

【定目标】：告诉AI你的需求，希望达成的目标 

【补要求】：告诉AI回答时注意什么，或者如何回复

### 提示词模板：

将提示词提炼为模板、实现提示词的复用、版本管理、动态变化等。

用于生成高质量提示(Prompts)的结构化方式，有效地与语言模型交互。

#### 字符串模板

```py
from langchain.prompts import PromptTemplate

prompt = PromptTemplate.from_template("你是一个{name},帮我起1个具有{county}特色的{sex}名字")
prompt.format(name="算命大师",county="法国",sex="女孩") # jupyter notebook里运行是输出prompt.format(...)结果
```

#### 对话模板

```python
# 对话模板具有关结构， chatmodels
from langchain.prompts import ChatPromptTemplate

chat_template = ChatPromptTemplate.from_messages(
[
    ("system", "你是一个起名大师。 你的名字叫{name}。"),
    ("human", "你好 {name}，你感觉好吗？"),
    ("ai", "你好！ 我状态很好哦！"),
    ("human", "你叫什么名字呢？"),
    ("ai", "你好！ 我叫{name}"),
    ("human", "{user_input}")
]
)

chat_template.format_messages(name="陈大师", user_input="你的爸爸是谁呢？")
```

#### 自定义模板的使用

```py
llm = OpenAI(
    model_name="Qwen/Qwen3-8B",
    temperature=0.9,
)
# 1. 创建模板(自定义模板)
template = PromptTemplate(
    input_variables=["concept", "audience"],
    template="请以{audience}能理解的方式解释{concept}"
)
# 2. 填充模板
prompt = template.format(
    concept="动物学", 
    audience="高中理科生"
)
# 3. 调用模型
response = llm(prompt)
print(response)
```

#### “少量示例提示”的模板

```py
llm = OpenAI(
    model_name="Qwen/Qwen3-8B",
    temperature=0.9,
)

# 样例
examples = [
    {"word": "高兴", "antonym": "悲伤"},
    {"word": "高", "antonym": "低"}
]

# 样例填充方式
example_prompt = PromptTemplate(
    input_variables=["word", "antonym"],
    template="单词: {word}\n反义词: {antonym}\n"
)

# 构建模板
few_shot_prompt = FewShotPromptTemplate(
    examples=examples, # 提供示例（examples）用于填充下面的示例模板
    example_prompt=example_prompt, # 定义示例的展示格式
    prefix="给出每个单词的反义词", # 在示例前添加说明
    suffix="单词: {input}\n反义词:", # 在示例后添加待预测的部分
    input_variables=["input"], # 输入变量
    example_separator="\n" # 示例之间的分隔符
)

response = llm(few_shot_prompt.format(input="优雅"))
print(response)
```

