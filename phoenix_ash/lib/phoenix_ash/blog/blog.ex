defmodule PhoenixAsh.Blog do
  use Ash.Api

  resources do
    registry PhoenixAsh.Blog.Registry
  end
end
