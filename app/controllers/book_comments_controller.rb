class BookCommentsController < ApplicationController
  def create
    book = Book.find(params[:book_id])
    @comment = BookComment.new(book_comment_params)
    @comment.user_id = current_user.id
    # comment = current_user.book_comments.new(book_comment_params)
    # サンプルコード（↑２行まとめると）
    @comment.book_id = book.id
    @comment.save
    # redirect_to book_path(book)↓同じ画面に戻る
    # redirect_to request.referer
  end

  def destroy
    @comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
    @comment.destroy
    #上サンプルコード採用：要復習
    # BookComment.find(params[:id]).destroy
    @book = Book.find(params[:book_id])
    # redirect_to book_path(params[:book_id])↓同じ画面に戻る
    # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

end

