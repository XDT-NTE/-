from flask import Flask, request, jsonify, render_template

from flask_cors import CORS

app = Flask(__name__,
            template_folder="templates",
            static_url_path='/static'

            )

CORS(app)  # 允许所有来源跨域请求


# 网页
@app.route('/')
def hello_world():  # put application's code here
    return render_template('index.html')


import os


@app.route('/upload', methods=['POST'])
def upload_file():
    # 获取POST请求的数据
    print(request.form)
    dirname = request.form.get('dirname')
    ml = request.form.get('ml')
    print("储存目录名: ", dirname)
    print("密令: ", ml)
    print(request.files)
    if 'upl' not in request.files:
        return 'No file part'

    file = request.files['upl']
    print(file.filename)

    if file.filename == '':
        return 'No selected file'
    if ml == "cz":
        # 获取当前工作目录
        current_directory = '/datadir'
        print(current_directory)
        # 创建名为 '用户输入的' 的子目录
        upload_directory = os.path.join(current_directory, dirname)

        if not os.path.exists(upload_directory):
            os.makedirs(upload_directory)  # 如果目录不存在，就创建它

        # 保存文件到指定目录
        file.save(os.path.join(upload_directory, file.filename))

        return f'mkdir: {dirname, ml}'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
    app.run(debug=True)
