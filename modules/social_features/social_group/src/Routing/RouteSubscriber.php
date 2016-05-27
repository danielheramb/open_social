<?php

/**
 * @file
 * Contains \Drupal\social_group\Routing\RouteSubscriber.
 */

namespace Drupal\social_group\Routing;

use Drupal\Core\Routing\RouteSubscriberBase;
use Symfony\Component\Routing\RouteCollection;

/**
 * Class RouteSubscriber.
 *
 * @package Drupal\social_group\Routing
 * Listens to the dynamic route events.
 */
class RouteSubscriber extends RouteSubscriberBase {

  /**
   * {@inheritdoc}
   */
  protected function alterRoutes(RouteCollection $collection) {
    // Route the group view page to group/{group}/timeline
    if ($route = $collection->get('entity.group.canonical')) {
      $route->setPath('/group/{group}/stream');
    }

    // Route the group members page to the group/{group}/membership
    if ($route = $collection->get('entity.group_content.group_membership.collection')) {
      $route->setPath('/group/{group}/membership');
    }
    // Override default title
    if ($route = $collection->get('view.group_members.page_group_members')) {
      $defaults = $route->getDefaults();
      $defaults['_title_callback'] = '\Drupal\social_group\Controller\SocialGroupController::groupMembersTitle';
      $route->setDefaults($defaults);
    }
  }

}