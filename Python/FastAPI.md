# 什么是 FastAPI？

FastAPI 是一个现代、快速（高性能）的 Python Web 框架，用于构建 API。它具有以下特点：

- **快速**：与 NodeJS 和 Go 相当的高性能
- **快速编码**：提高开发速度约 200%-300%
- **更少 bug**：减少约 40% 的人为错误
- **直观**：强大的编辑器支持
- **简单**：易于使用和学习
- **简短**：最小化代码重复
- **稳健**：生产级别的代码
- **基于标准**：完全兼容 API 开放标准（如 OpenAPI 和 JSON Schema）

# 第一个FastAPI

```bash
pip install fastapi
pip install uvicorn  # ASGI 服务器,支持异步
```

### 第一个hello world

```py
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.get("/items/{item_id}")
def read_item(item_id: int):
    return {"item_id": item_id}
```

###  运行应用

```
uvicorn main:app --reload
```

- `main`: 模块名（`main.py`）
- `app`: FastAPI 实例名
- `--reload`: 开发时自动重载（生产环境不要使用）

**配置快速启动**

```py
if __name__ == "__main__":
    uvicorn.run("main:app", reload=True, host="0.0.0.0", port=8000)
```

之后：**python main.py** 启动

### 访问 API

- 打开浏览器访问 `http://127.0.0.1:8000/`
- 交互式 API 文档: `http://127.0.0.1:8000/docs` (Swagger UI)
- 备用 API 文档: `http://127.0.0.1:8000/redoc` (ReDoc)

# 获取请求里的参数和请求头

### 1. 接收URL路径参数

```py
@app.get("/items/{item_id}")
async def read_item(item_id: int):
    return {"item_id": item_id}
```

### 2. 接收URL查询参数

```py
@app.get("/items/")
async def read_items(skip: int = 0, limit: int = 10):
    return {"skip": skip, "limit": limit}
```

### 3. 接收请求体参数

#### 方法1：使用映射的模型接收

首先定义一个Pydantic模型：

```py
class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None
```

然后在路由中使用：

```py
@app.post("/items")
async def create_item(item: Item):
    return item
```

#### 方法2：获取request.body

```py
@app.post("/items/")
async def create_item(request: Request):
    # 获取原始字节
    body_bytes = await request.body()
    # 获取JSON格式（如果是JSON请求）
    body_json = await request.json()
    return {
        "body_bytes": body_bytes,
        "body_json": body_json
    }
```

### 4.接收请求头里的参数

#### 方法1：使用 `Header` 参数

```py
from fastapi import FastAPI, Header

app = FastAPI()

@app.get("/items/")
async def read_items(user_agent: str = Header(None)):
    return {"User-Agent": user_agent}
```

#### 方法2：获取特定请求头

```py
from fastapi import FastAPI, Request

app = FastAPI()

@app.get("/items/")
async def read_items(request: Request):
     # request.headers为所有请求头
    user_agent = request.headers.get("user-agent")
    return {"User-Agent": user_agent}
```

# 路由模块化开发

### **文件结构**

```
app/
├── main.py
├── routers/
│   ├── items.py
│   └── users.py
```

**routers/user.py**

```py
from fastapi import APIRouter

user = APIRouter()

@user.get("/item1")
async def read_items():
    return [{"name": "Item 1"}, {"name": "Item 2"}]
```

**main.py**

```py
from fastapi import FastAPI
import uvicorn
from routers.user import user # routers文件夹下的 APIRouter() 要复制给user然后导出
app = FastAPI()

app.include_router(user, prefix="/user", tags=["users模块"]) # 添加路由


if __name__ == "__main__":
    uvicorn.run("main:app", reload=True, host="0.0.0.0", port=8000)
```

