<?php


declare(strict_types=1);

namespace demo03;

use Doctrine\Common\Annotations\SimpleAnnotationReader;
use Doctrine\Common\Cache\ArrayCache;
use Doctrine\Common\Cache\FilesystemCache;
use Doctrine\ORM\EntityManager;
use Doctrine\ORM\Configuration;
use Doctrine\ORM\Mapping\Driver\AnnotationDriver;
use Doctrine\ORM\Tools\Setup;


chdir(dirname(__DIR__));
require 'vendor/autoload.php';

$params = [
    'driver'  => 'pdo_mysql',
    'user'    => 'root',
    'password'=> '',
    'dbname'  => 'foo',
];

$prod = false;

$paths = ['src/Entity'];

$config = Setup::createAnnotationMetadataConfiguration($paths, !$prod);
$em = EntityManager::create($params, $config);

class Post
{
    private $id;
    private $title;
    private $text;

    public function getId()
    {
        return $this->id;
    }

    public function getTitle(): string
    {
        return $this->title;
    }

    public function setTitle(string $title): void
    {
        $this->title = $title;
    }

    public function getText(): string
    {
        return $this->text;
    }

    public function setText(string $text): void
    {
        $this->text = $text;
    }

}

$post = new Post();
$post->setTitle('Title 0');
$post->setText('Text 0');
$em->persist($post);

$post1 = new Post();
$post1->setTitle('Title 1');
$post1->setText('Text 1');
$em->persist($post1);

$post2 = new Post();
$post2->setTitle('Title 2');
$post2->setText('Text 2');
$em->persist($post2);

$post3 = new Post();
$post3->setTitle('Title 3');
$post3->setText('Text 3');
$em->persist($post3);

$em->flush();

// Pattern: Unit of work
// $toInsert = []
// $toUpdate = []
// $toDelete = []

// Identity Map
// $entities = [
//    2 => $post4
//    3 => $post5
//]

// Data Mapper

$repo = $em->getRepository(Post::class);

$post4 = $repo->find(2);
$post4->setText('New Text');

$em->flush();

##############################################

$repository = $em->getRepository(Post::class);

$slug = 'first-post';

$post5 = $repository->findActiveBySlug($slug);

$em->remove($post5);

$em->flush();

##############################################

Post::findOne(10);
$post->save();



