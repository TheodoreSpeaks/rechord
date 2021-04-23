import os
import pickle
from app import app
from flask import Flask, jsonify, request, flash, redirect, url_for, send_file
from werkzeug.utils import secure_filename


SAVE_DIR = "../data/"
FILE_DIR = "../data/"
if not os.path.isdir(SAVE_DIR):
    os.mkdir(SAVE_DIR)


def save_dict(dict, name):
    with open(name + '.pkl', 'wb') as f:
        pickle.dump(dict, f, 0)


def load_dict(name):
    with open(name + '.pkl', 'rb') as f:
        return pickle.load(f)


def upload_file(post_id):
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            print('No file part')
            return None
        file = request.files['file']
        # if user does not select file, browser also
        # submit an empty part without filename
        if file.filename == '':
            print('No selected file')
            return None
        if file:
            path = SAVE_DIR + str(post_id) + '/'
            frontend_file_path = FILE_DIR + str(post_id) + '/'
            filename = 'post_' + secure_filename(file.filename)
            file_path = os.path.join(path, filename)
            file.save(file_path)
            frontend_file_path = os.path.join(frontend_file_path, filename)
            return frontend_file_path


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


@app.route('/single_post/<int:post_id>', methods=['GET'])
def single_post(post_id):
    post_dir = SAVE_DIR + str(post_id) + '/'
    if not os.path.isdir(post_dir):
        return jsonify({'status': 'no such post with post_id %s' % (str(post_id))})
    post_file = post_dir + 'post_file'
    post = load_dict(post_file)
    return jsonify(post)


@app.route('/get_file/<file_path>', methods=['GET'])
def get_file(file_path):
    return send_file(file_path)


@app.route('/new_post', methods=['POST'])
def new_post():
    raw_data = request.form.to_dict(flat=False)
    data = {}
    for k, v in raw_data.items():
        data[k] = v[0]
    directories = os.listdir(SAVE_DIR)
    post_id = str(len(directories))
    data['post_id'] = post_id
    post_path = os.path.join(SAVE_DIR, post_id)
    if not os.path.isdir(post_path):
        os.mkdir(post_path)
    filename = upload_file(post_id)
    if filename is not None:
        data['file'] = filename
    post_file = post_path + '/' + 'post_file'
    save_dict(data, post_file)
    return jsonify({'status': 'success'})


@app.route('/new_comment/<int:post_id>', methods=['POST'])
def new_comment(post_id):
    raw_data = request.form.to_dict(flat=False)
    data = {}
    for k, v in raw_data.items():
        data[k] = v[0]
    post_dir = None
    for root, directory, files in os.walk(SAVE_DIR):
        if str(post_id) in directory:
            post_dir = root + str(post_id) + '/'
            break
    if post_dir is None:
        return jsonify({'status': 'no such post with post id %s found' % post_id})
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
        return jsonify({'status': 'successfully added comment to post with post id %s' % post_id})


@app.route('/new_track/<int:post_id>', methods=['POST'])
def new_track(post_id):
    raw_data = request.form.to_dict(flat=False)
    data = {}
    for k, v in raw_data.items():
        data[k] = v[0]
    post_dir = None
    for root, directory, files in os.walk(SAVE_DIR):
        if str(post_id) in directory:
            post_dir = root + str(post_id) + '/'
            break
    if post_dir is None:
        return jsonify({'status': 'no such post with post id %s found' % post_id})
    else:
        post_file = post_dir + 'post_file'
        post = load_dict(post_file)
        if 'tracks' in post.keys():
            tracks = post['tracks']
            data['comment_id'] = len(tracks)
        else:
            tracks = []
            data['comment_id'] = len(tracks)
        filename = upload_file(post_id)
        data['file'] = filename
        tracks.append(data)
        post['tracks'] = tracks
        save_dict(post, post_file)
        return jsonify({'status': 'successfully added comment to post with post id %s' % post_id})


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
        filename = upload_file(post_id)
        if filename is not None:
            data['file'] = filename
        post_file = post_path + '/' + 'post_file'
        save_dict(data, post_file)
        return jsonify({'status': 'success'})
    return '''
        <!doctype html>
        <title>Upload new File</title>
        <h1>Post</h1>
        <form method=post enctype=multipart/form-data>
          <label for="title"> Title </label>
          <input type="text" name="title">
          <label for="user"> User </label>
          <input type="text" name="user">
          <label for="file"> File </label>
          <input type=file name=file>
          <input type=submit value=Submit>
        </form>
        '''
    # if data:
    #     post_id = data['postid'][0]
    #     post_dir = None
    #     for root, directory, files in os.walk(SAVE_DIR):
    #         if str(post_id) in directory:
    #             post_dir = root + str(post_id) + '/'
    #             break
    #     if post_dir is None:
    #         return jsonify({'status': 'no such post with post id %s found' % post_id})
    #     else:
    #         post_file = post_dir + 'post_file'
    #         post = load_dict(post_file)
    #         if 'comments' in post.keys():
    #             comments = post['comments']
    #             data['comment_id'] = len(comments)
    #         else:
    #             comments = []
    #             data['comment_id'] = len(comments)
    #         filename = upload_file(post_id)
    #         data['file'] = filename
    #         comments.append(data)
    #         post['comments'] = comments
    #         save_dict(post, post_file)
    #         return jsonify({'status': 'successfully added comment to post with post id %s' % post_id})
    #
    # return '''
    #     <!doctype html>
    #     <title>Upload new File</title>
    #     <h1>Post</h1>
    #     <form method=post enctype=multipart/form-data>
    #       <label for="postid"> postid </label>
    #       <input type="text" name="postid">
    #       <label for="comment"> Comments </label>
    #       <input type="text" name="comment">
    #       <label for="user"> User </label>
    #       <input type="text" name="user">
    #       <label for="file"> File </label>
    #       <input type=file name=file>
    #       <input type=submit value=Submit>
    #     </form>
    #     '''