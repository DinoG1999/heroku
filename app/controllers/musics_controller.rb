class MusicsController < ApplicationController
    def show
        @music = Music.find(params[:id])
        
        v = @music.views += 1
        @music.update_attribute "views", v
    end
    
    def new
        @music = Music.new
    end
    
    def create
        @music = Music.create(params[:music].permit(:title, :description, :file, :image, :genre_id))
        @music.views = 0
        @music.user_id = current_user.id
        
        if @music.save
          redirect_to index_path, :notice => "A new list has been successfully created"  
        else
          render "new"
        end
    end
    
    def edit
    end
    
    def update
    end
    
    def upvote
        @music = Music.find(params[:id])
        @music.upvote_from current_user
        
        redirect_to root_path
    end
    
    def downvote
        @music = Music.find(params[:id])
        @music.downvote_from current_user
        
        redirect_to root_path
    end
    
    def destroy
        @music = Music.find(params[:id])
        @music.destroy
        redirect_to index_path, :notice => "Your list has been deleted"
    end
end
