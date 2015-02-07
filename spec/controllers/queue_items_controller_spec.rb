require 'spec_helper'

describe QueueItemsController do

  describe "GET index" do
    context "for authenticated users" do
      it "populates an array of all queue items for authenticated users" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item1 = Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        get :index, id: user.id
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end
    end
    context "for unauthenticated users" do
      it "redirects to the sign-in page" do
        user = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: user)
        queue_item2 = Fabricate(:queue_item, user: user)
        get :index, id: user.id
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST create" do
    context "for authenticated users" do
      context "if the video is not already in the queue" do
        it "redirects to the my queue page" do
          session[:user_id] = Fabricate(:user).id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(response).to redirect_to my_queue_path
        end
        it "creates a queue item" do
          session[:user_id] = Fabricate(:user).id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.count).to eq(1)
        end
        it "creates the queue item that is associated with the video" do
          session[:user_id] = Fabricate(:user).id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.first.video).to eq(video)
        end
        it "creates the queue item that is associated with the sign in user" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          video = Fabricate(:video)
          post :create, video_id: video.id
          expect(QueueItem.first.user).to eq(user)
        end
        it "puts the video as the last one in the queue" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          video1 = Fabricate(:video)
          queue_item = Fabricate(:queue_item, video: video1, user: user)
          video2 = Fabricate(:video)
          post :create, video_id: video2.id
          expect(QueueItem.last.video).to eq(video2)
        end
      end
      context "if the video is already in the queue" do
        it "does not add the video to the queue if the video is already in the queue" do
          user = Fabricate(:user)
          session[:user_id] = user.id
          video1 = Fabricate(:video)
          queue_item = Fabricate(:queue_item, video: video1, user: user)
          post :create, video_id: video1.id
          expect(QueueItem.last.video).to eq(video1)
        end
      end
    end
    context "for unauthenticated users" do
      it "redirects to the sign in page" do
        post :create, video_id: 10
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "DELETE destroy" do
    context "for authenticated users" do
      it "redirects to the my queue page" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes the queue item" do
        user = Fabricate(:user)
        session[:user_id] = user.id
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not allow you to delete other user's queues" do
        user = Fabricate(:user)
        user2 = Fabricate(:user)
        session[:user_id] = user2.id
        queue_item = Fabricate(:queue_item, user: user)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "for unauthenticated users" do
      it "redirects to sign-in page for unauthenticated users" do
        queue_item = Fabricate(:queue_item)
        delete :destroy, id: 10
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end