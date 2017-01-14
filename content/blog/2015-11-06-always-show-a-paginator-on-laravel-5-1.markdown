Title: Always show a paginator on Laravel 5.1
Category: Blog
Tags: laravel
Date: 2015-11-06 22:31:19

Laravel 5.1 provides a convenient way to [show a paginator](http://laravel.com/docs/5.1/pagination#displaying-results-in-a-view) when rendering a collection. When you build a query and use the method `paginate()`, a new method is available in your Blade template to print the paginator:

``` php
{!! $collection->render() !!}
```

This method renders ―by default and when used with `paginate()`― a Bootstrap 3-compliant paginator like on the left side of the following image:

![Default paginator](/images/2015/11/laravel-paginator-normal.png)

It's pretty cool but the paginator will not be rendered if the collection has only one page:

![Empty paginator](/images/2015/11/laravel-paginator-none.png)

On the side of Laravel `paginate()` returns a `Illuminate\Pagination\LengthAwarePaginator`. Let's check the rendering.

``` php
<?php

class LengthAwarePaginator
{
    // ...
    public function render(Presenter $presenter = null)
    {
        if (is_null($presenter) && static::$presenterResolver) {
            $presenter = call_user_func(static::$presenterResolver, $this);
        }

        $presenter = $presenter ?: new BootstrapThreePresenter($this);

        return $presenter->render();
    }
    // ...
```

We see that `$collection->render()` calls the method `render()` of the Presenter given as an argument or `Illuminate\Pagination\BootstrapThreePresenter` by default.

Let's check the rendering of the default Presenter:

``` php
<?php

class BootstrapThreeProvider
{

    // ...
    public function render()
    {
        if ($this->hasPages()) {
            return sprintf(
                '<ul class="pagination">%s %s %s</ul>',
                $this->getPreviousButton(),
                $this->getLinks(),
                $this->getNextButton()
            );
        }

        return '';
    }
    // ...
```

So the paginator is not rendered if `BootstrapThreePresenter#hasPages()` returns `false`:

``` php
<?php

class BootstrapThreeProvider
{
    // ...
    public function hasPages()
    {
        return $this->paginator->hasPages();
    }
```

Well, the solution to render the paginator in any case is quite easy now. Let's create a new Presenter which extends `BootstrapThreePresenter` and overrides the method `hasPages()`:

``` php
<?php
namespace App\Presenters;

use Illuminate\Pagination\BootstrapThreePresenter;

class PermanentBootstrapPresenter extends BootstrapThreePresenter
{
   public function hasPages()
   {
      return true;
   }
}
```
Save the file in `app/Presenters/PermanentBootstrapPresenter.php`.

Now that we have our custom Presenter we need to tell the collection to use it instead of `BootstrapThreePresenter`. To do that, replace the call

``` php
{!! $collection->render() !!}
```

with the following:

``` php
{!! $collection->render(new App\Presenters\PermanentBootstrapPresenter($collection)) !!}
```

Now the paginator will be rendered even if there is only one page:

![Permanent Paginator](/images/2015/11/laravel-paginator-permanent.png)

_Enjoy!_
