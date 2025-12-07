class RecipesController < ApplicationController
  before_action :authorized, except: [:index, :show]
  before_action :set_recipe, only: [:show, :update, :destroy]
  before_action :require_owner, only: [:update, :destroy]

  def index
    recipes = Recipe.all.order(created_at: :desc)
    render json: recipes
  end

  def show
    render json: @recipe
  end

  def create
    recipe = current_user.recipes.build(recipe_params)
    if recipe.save
      render json: recipe
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @recipe.update(recipe_params)
      render json: @recipe
    else
      render json: { errors: @recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @recipe.destroy
    render json: { message: "Recipe deleted" }
  end

  private

  def set_recipe
    @recipe = Recipe.find(params[:id])
  end

  def require_owner
    render json: { error: "Not authorized" }, status: :forbidden unless @recipe.user_id == current_user.id
  end

  def recipe_params
    params.permit(:title, :ingredients, :instructions, :image_url)
  end
end
