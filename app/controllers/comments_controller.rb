class CommentsController < ApplicationController
    before_action :find_music   #Pred vsem najprej izvede to funkcijo
    #Only - Funkcijo izvede le za določene funkcije
    before_action :find_comment, only: [:destroy, :edit, :update]


    def new
        #Ustvarimo novo Komentar
        @comment = Comment.new
    end

    def create
        #Iz forma dobimo podatke in jih shranimo v spremenljivko
        @comment = @music.comments.create(params[:comment].permit(:content))
        @comment.user_id = current_user.id  #V spremenljivko shranimo user_id
        @comment.save   #Shranimo v bazo
        
        #Potrebno za jQuery, ni mi čist jasno ka se dogaja
        respond_to do |format|
           if @comment.save
            format.html { redirect_to music_path(@music), notice: "Comment was successfully made" }
            format.json { render :_comments, status: :created, location: @comment }
            format.js {render layout: false}
           else
            format.html { render "new" }
            format.json { render json: @comment.errors, status: :unprocessable__entity }
            format.js {render layout: false}
           end
        end
    end
    
    def edit
        
    end
    
    def update
        #Iz forma dobimo podatke in jih shranimo v comment spremenljivko
        respond_to do |format|
          if @comment.update(params[:comment].permit(:content))
            format.html { redirect_to music_path(@music), notice: 'Post was successfully updated.' }
            format.json { render :_comments, status: :created, location: @comment }
            format.js
          else
            format.html { render :new }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
            format.js
          end
        end
    end
    
    def destroy
        #Comment spremenljivko dobimo iz find_comment funkcije
        @comment.destroy
        
        respond_to do |format|
          format.html do
            flash[:success] = 'Comment deleted.'
            redirect_to music_path(@music)
          end
          format.js # JavaScript response
        end
    end
    
    
    private
    #Custom funkcije
    
    def find_music
        @music = Music.find(params[:music_id])  #Poiščemo glasbo
    end
    
    def find_comment
        @comment = Comment.find(params[:id])    #Poiščemo komentar
    end
    
end
