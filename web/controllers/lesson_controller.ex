defmodule LearnReact.LessonController do
  use LearnReact.Web, :controller

  alias LearnReact.Lesson

  def index(conn, _params) do
    lessons = Repo.all(Lesson)
    render(conn, "index.html", lessons: lessons)
  end

  def new(conn, _params) do
    changeset = Lesson.changeset(%Lesson{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"lesson" => lesson_params}) do
    changeset = Lesson.changeset(%Lesson{}, lesson_params)

    case Repo.insert(changeset) do
      {:ok, _lesson} ->
        conn
        |> put_flash(:info, "Lesson created successfully.")
        |> redirect(to: lesson_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => slug}) do
    lesson = Repo.get_by!(Lesson, slug: slug)
    |> Repo.preload([:course])

    cond do
      lesson.notes ->
        render(conn, "show.html", lesson: lesson)
      true ->
        render(conn, "show_video_only.html", lesson: lesson)
    end
  end

  def edit(conn, %{"id" => slug}) do
    lesson = Repo.get_by!(Lesson, slug: slug)
    |> Repo.preload([:course])
    changeset = Lesson.changeset(lesson)
    render(conn, "edit.html", lesson: lesson, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "lesson" => lesson_params}) do
    lesson = Repo.get_by!(Lesson, slug: slug)
    changeset = Lesson.changeset(lesson, lesson_params)

    case Repo.update(changeset) do
      {:ok, lesson} ->
        conn
        |> put_flash(:info, "Lesson updated successfully.")
        |> redirect(to: lesson_path(conn, :show, lesson))
      {:error, changeset} ->
        render(conn, "edit.html", lesson: lesson, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug}) do
    lesson = Repo.get_by!(Lesson, slug: slug)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(lesson)

    conn
    |> put_flash(:info, "Lesson deleted successfully.")
    |> redirect(to: lesson_path(conn, :index))
  end
end
