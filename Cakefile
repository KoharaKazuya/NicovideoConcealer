util = require('util')
exec = require('child_process').exec

# 設定
SOURCE_DIR = './src'
TARGET_DIR = './build'
TARGET_FILENAME = 'NicovideoConcealer.user.js'

#コンパイルするファイル群
files = [
    'GM_prefix.coffee'
    'NicovideoConcealer.coffee'
]

# タスクの登録
task 'build', 'CoffeeScriptをまとめてひとつのJavaScriptにします', (options) ->

    # ファイルを構成する
    util.log('まとめるファイルを構成します')
    fileList = []

    for filename, index in files
        file = SOURCE_DIR + '/' + filename
        fileList.push(file)
        util.log("#{index + 1}) #{file}")

    fileList = fileList.join(' ')

    # コンパイルオプション
    option = "-cj #{TARGET_DIR}/#{TARGET_FILENAME} #{fileList}"

    # コンパイル実行
    util.log('コンパイルします')
    exec "coffee #{option}", (error, stdout, stderr) -> 

        util.log(error) if error
        util.log(stdout) if stdout
        util.log(stderr) if stderr

        if error
            util.log('失敗しました')
        else
            util.log('成功しました')