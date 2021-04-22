import os
import pickle
from app import app
from flask import Flask, jsonify, request, flash, redirect, url_for, send_file
from werkzeug.utils import secure_filename


SAVE_DIR = "app/data/"


def save_dict(dict, name):
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(dict, f, 0)


def load_dict(name):
    with open(name + '.pkl', 'rb') as f:
        return pickle.load(f)


# @app.route('/')
# def homepage():
#
#     return jsonify({'status': 'OK'})


@app.route('/all_post', methods=['GET'])
def all_post():
    directories = os.listdir(SAVE_DIR)
    feed = {}
    posts = []
    for dir in directories:
        post_file = SAVE_DIR + dir + '/post_file'
        post = load_dict(post_file)
        if 'comments' in post.keys():
            post.pop('comments')
        posts.append(post)
    feed['feed'] = posts
    return jsonify(feed)


@app.route('/new_post', methods=['POST'])
def new_post():
    data = request.get_json()
    directories = os.listdir(SAVE_DIR)
    post_id = len(directories)
    data['post_id'] = post_id
    post_path = os.path.join(SAVE_DIR, post_id)
    if not os.path.isdir(post_path):
        os.mkdir(post_path)
    post_file = post_path + '/' + 'post_file'
    save_dict(data, post_file)
    return jsonify({'status': 'success'})


@app.route('/new_comment/<int:post_id>', methods=['POST'])
def new_comment(post_id):
    data = request.get_json()

    post_dir = None
    for root, directory, files in os.walk(SAVE_DIR):
        if directory == str(post_id):
            post_dir = os.path.join(root, directory)
            break
    if post_dir is None:
        return jsonify({'status': 'no such post with post id %d found' % post_id})
    else:
        post_file = post_dir+'post_file'
        post = load_dict(post_file)
        if 'comments' in post.keys():
            comments = post['comments']
            data['comment_id'] = len(comments)
            comments.append(data)
            post['comments'] = comments
        else:
            comments = []
            data['comment_id'] = len(comments)
            comments.append(data)
            post['comments'] = comments
        save_dict(post, post_file)
        return jsonify({'status': 'successfully added comment to post with post id %d' % post_id})


@app.route('/upload_file', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file:
            print(os.getcwd())
            filename = secure_filename(file.filename)
            file.save(os.path.join('app/data/1/', filename))
            return send_file(os.path.join('data/1/', filename))
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''


@app.route('/', methods=['GET', 'POST'])
def homepage():
    data = request.form.to_dict(flat=False)
    print(data)
    if data:
        directories = os.listdir(SAVE_DIR)
        post_id = str(len(directories))
        data['post_id'] = post_id
        post_path = os.path.join(SAVE_DIR, post_id)
        if not os.path.isdir(post_path):
            os.mkdir(post_path)
        post_file = post_path + '/' + 'post_file'
        save_dict(data, post_file)
        return jsonify({'status': 'success'})
    # if data:
    #     post_id = data['postid'][0]
    #     post_dir = None
    #     for root, directory, files in os.walk(SAVE_DIR):
    #         if post_id in directory:
    #             post_dir = os.path.join(root, post_id)
    #             break
    #     if post_dir == None:
    #         return jsonify({'status': 'no such post with post id %s found' % post_id})
    #     else:
    #         post_file = post_dir + '/post_file'
    #         post = load_dict(post_file)
    #         if 'comments' in post.keys():
    #             comments = post['comments']
    #             comments.append(data)
    #             post['comments'] = comments
    #         else:
    #             comments = []
    #             comments.append(data)
    #             post['comments'] = comments
    #         save_dict(post, post_file)
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Post</h1>
    <form method=post enctype=multipart/form-data>
      <label for="title"> Title </label>
      <input type="text" name="title">
      <label for="user"> User </label>
      <input type="text" name="user">
      <input type=submit value=Submit>
    </form>
    '''